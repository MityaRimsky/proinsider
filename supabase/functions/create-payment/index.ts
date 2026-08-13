import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type CloudPaymentsOrderResponse = {
  Success?: boolean;
  Message?: string | null;
  Model?: {
    Id?: string;
    Number?: number;
    Url?: string;
    Status?: string;
    Amount?: number;
    Currency?: string;
    CreatedDateIso?: string;
  } | null;
};

type SubscriptionBehavior = "CreateWeekly" | "CreateMonthly";

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

function basicAuth(publicId: string, apiSecret: string): string {
  return `Basic ${btoa(`${publicId}:${apiSecret}`)}`;
}

function getSubscriptionBehavior(unitType: string): SubscriptionBehavior | null {
  switch (unitType) {
    case "week":
      return "CreateWeekly";
    case "month":
      return "CreateMonthly";
    default:
      return null;
  }
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  try {
    const authorization = req.headers.get("Authorization");

    if (!authorization?.startsWith("Bearer ")) {
      return jsonResponse({ error: "unauthorized" }, 401);
    }

    const accessToken = authorization.replace("Bearer ", "").trim();

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const cloudPaymentsPublicId = Deno.env.get("CLOUDPAYMENTS_PUBLIC_ID");
    const cloudPaymentsApiSecret = Deno.env.get("CLOUDPAYMENTS_API_SECRET");
    const successRedirectUrl = Deno.env.get(
      "CLOUDPAYMENTS_SUCCESS_REDIRECT_URL",
    );
    const failRedirectUrl = Deno.env.get(
      "CLOUDPAYMENTS_FAIL_REDIRECT_URL",
    );

    if (
      !supabaseUrl ||
      !serviceRoleKey ||
      !cloudPaymentsPublicId ||
      !cloudPaymentsApiSecret
    ) {
      console.error("Required environment variables are missing");

      return jsonResponse({ error: "server_configuration_error" }, 500);
    }

    /*
     * Отдельный серверный клиент.
     * Service role используется только внутри Edge Function.
     */
    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });

    /*
     * Не доверяем user_id из FlutterFlow.
     * Пользователя определяем только по JWT.
     */
    const {
      data: { user },
      error: userError,
    } = await admin.auth.getUser(accessToken);

    if (userError || !user) {
      console.error("User authentication failed:", userError);

      return jsonResponse({ error: "unauthorized" }, 401);
    }

    let body: {
      option_id?: number;
    };

    try {
      body = await req.json();
    } catch {
      return jsonResponse({ error: "invalid_json" }, 400);
    }

    const optionId = Number(body.option_id);

    if (!Number.isInteger(optionId) || optionId <= 0) {
      return jsonResponse(
        {
          error: "invalid_option_id",
          message: "option_id must be a positive integer",
        },
        400,
      );
    }

    /*
     * Цену нельзя принимать от приложения.
     * Берём её только из subscription_options.
     */
    const { data: option, error: optionError } = await admin
      .from("subscription_options")
      .select(`
        id,
        plan_id,
        name,
        price,
        quantity,
        unit_type,
        option_order,
        subscription_plans (
          name
        )
      `)
      .eq("id", optionId)
      .maybeSingle();

    if (optionError) {
      console.error("Failed to read subscription option:", optionError);

      return jsonResponse({ error: "database_error" }, 500);
    }

    if (!option) {
      return jsonResponse(
        {
          error: "option_not_found",
          message: "Subscription option was not found",
        },
        404,
      );
    }

    const amount = Number(option.price);

    if (!Number.isFinite(amount) || amount <= 0) {
      return jsonResponse(
        {
          error: "invalid_option_price",
          message: "Subscription option has an invalid price",
        },
        422,
      );
    }

    const unitType = String(option.unit_type ?? "");
    const subscriptionBehavior = getSubscriptionBehavior(unitType);
    const paymentType = subscriptionBehavior
      ? "subscription_initial"
      : "one_time";

    if (!subscriptionBehavior && unitType !== "forecast") {
      return jsonResponse(
        {
          error: "unsupported_option_unit_type",
          message: "unit_type must be forecast, week or month",
        },
        422,
      );
    }

    if (subscriptionBehavior) {
      /*
       * 1. Проверяем действующую Live-подписку.
       *
       * cancelled означает, что автопродление отключено,
       * но оплаченный доступ действует до expires_at.
       */
      const now = new Date().toISOString();

      const {
        data: existingSubscription,
        error: existingSubscriptionError,
      } = await admin
        .from("user_live_subscriptions")
        .select("id, status, expires_at, provider_subscription_id")
        .eq("user_id", user.id)
        .in("status", ["active", "past_due", "cancelled"])
        .gt("expires_at", now)
        .order("expires_at", { ascending: false })
        .limit(1)
        .maybeSingle();

      if (existingSubscriptionError) {
        console.error(
          "Failed to check existing Live subscription:",
          existingSubscriptionError,
        );

        return jsonResponse(
          {
            error: "database_error",
            message: "Не удалось проверить текущую подписку",
          },
          500,
        );
      }

      if (existingSubscription) {
        return jsonResponse(
          {
            error: "live_subscription_already_active",
            message: "У вас уже есть действующая подписка Live",
            subscription: {
              id: existingSubscription.id,
              status: existingSubscription.status,
              access_until: existingSubscription.expires_at,
            },
          },
          409,
        );
      }

      /*
       * 2. Проверяем свежий pending-платёж Live.
       *
       * Защищает от двойного клика и повторного создания
       * нескольких ссылок CloudPayments.
       */
      const pendingSince = new Date(
        Date.now() - 10 * 60 * 1000,
      ).toISOString();

      const {
        data: existingPendingPayment,
        error: existingPendingPaymentError,
      } = await admin
        .from("payments")
        .select("id, invoice_id, created_at, status")
        .eq("user_id", user.id)
        .eq("provider", "cloudpayments")
        .eq("payment_type", "subscription_initial")
        .eq("status", "pending")
        .gte("created_at", pendingSince)
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle();

      if (existingPendingPaymentError) {
        console.error(
          "Failed to check pending Live payment:",
          existingPendingPaymentError,
        );

        return jsonResponse(
          {
            error: "database_error",
            message: "Не удалось проверить текущий платёж",
          },
          500,
        );
      }

      if (existingPendingPayment) {
        return jsonResponse(
          {
            error: "live_subscription_payment_already_pending",
            message:
              "Платёж для подключения Live уже создан. Завершите оплату или попробуйте позже.",
            payment: {
              id: existingPendingPayment.id,
              invoice_id: existingPendingPayment.invoice_id,
              created_at: existingPendingPayment.created_at,
            },
          },
          409,
        );
      }
    }

    const invoiceId = `cp_${crypto.randomUUID()}`;

    const planRelation = option.subscription_plans as
      | { name?: string }
      | Array<{ name?: string }>
      | null;

    const planName = Array.isArray(planRelation)
      ? planRelation[0]?.name
      : planRelation?.name;

    const description = [planName, option.name].filter(Boolean).join(" — ");

    const { data: payment, error: paymentError } = await admin
      .from("payments")
      .insert({
        user_id: user.id,
        option_id: option.id,
        provider: "cloudpayments",
        status: "pending",
        amount,
        currency: "RUB",
        invoice_id: invoiceId,
        payment_type: paymentType,
      })
      .select(`
        id,
        invoice_id,
        amount,
        currency,
        status,
        created_at
      `)
      .single();

    if (paymentError) {
      console.error("Failed to create payment:", paymentError);

      return jsonResponse({ error: "payment_creation_failed" }, 500);
    }

    const cloudPaymentsRequest: Record<string, unknown> = {
      Amount: amount,
      Currency: "RUB",
      Description: description || `Подписка №${option.id}`,
      Email: user.email ?? undefined,
      InvoiceId: invoiceId,
      AccountId: user.id,
      SendEmail: false,
      RequireConfirmation: false,
      CultureName: "ru-RU",
      JsonData: {
        proinsider: {
          user_id: user.id,
          option_id: option.id,
          plan_id: option.plan_id,
          payment_id: payment.id,
          unit_type: unitType,
          quantity: option.quantity,
        },
      },
    };

    if (subscriptionBehavior) {
      cloudPaymentsRequest.SubscriptionBehavior = subscriptionBehavior;
    }

    if (successRedirectUrl) {
      cloudPaymentsRequest.SuccessRedirectUrl = successRedirectUrl;
    }

    if (failRedirectUrl) {
      cloudPaymentsRequest.FailRedirectUrl = failRedirectUrl;
    }

    let cloudPaymentsResponse: Response;

    try {
      cloudPaymentsResponse = await fetch(
        "https://api.cloudpayments.ru/orders/create",
        {
          method: "POST",
          headers: {
            Authorization: basicAuth(
              cloudPaymentsPublicId,
              cloudPaymentsApiSecret,
            ),
            "Content-Type": "application/json",
            "X-Request-ID": crypto.randomUUID(),
          },
          body: JSON.stringify(cloudPaymentsRequest),
        },
      );
    } catch (error) {
      console.error("CloudPayments connection error:", error);

      await admin
        .from("payments")
        .update({
          status: "failed",
          failure_message: "CloudPayments connection error",
        })
        .eq("id", payment.id);

      return jsonResponse(
        {
          error: "cloudpayments_unavailable",
          message: "Не удалось соединиться с CloudPayments",
        },
        502,
      );
    }

    const responseText = await cloudPaymentsResponse.text();
    let cloudPaymentsResult: CloudPaymentsOrderResponse;

    try {
      cloudPaymentsResult = JSON.parse(responseText);
    } catch {
      console.error(
        "Invalid CloudPayments response:",
        cloudPaymentsResponse.status,
        responseText,
      );

      await admin
        .from("payments")
        .update({
          status: "failed",
          failure_message: "Invalid CloudPayments response",
        })
        .eq("id", payment.id);

      return jsonResponse({ error: "invalid_cloudpayments_response" }, 502);
    }

    const paymentUrl = cloudPaymentsResult.Model?.Url;
    const cloudPaymentsOrderId = cloudPaymentsResult.Model?.Id;

    if (
      !cloudPaymentsResponse.ok ||
      cloudPaymentsResult.Success !== true ||
      !paymentUrl
    ) {
      console.error("CloudPayments rejected order:", cloudPaymentsResult);

      await admin
        .from("payments")
        .update({
          status: "failed",
          failure_message:
            cloudPaymentsResult.Message ??
            "CloudPayments order creation failed",
          provider_payload: cloudPaymentsResult,
        })
        .eq("id", payment.id);

      return jsonResponse(
        {
          error: "cloudpayments_order_failed",
          message:
            cloudPaymentsResult.Message ??
            "CloudPayments не создал ссылку на оплату",
        },
        502,
      );
    }

    const { error: updatePaymentError } = await admin
      .from("payments")
      .update({
        provider_payload: cloudPaymentsResult,
      })
      .eq("id", payment.id);

    if (updatePaymentError) {
      console.error(
        "Failed to save CloudPayments order response:",
        updatePaymentError,
      );
    }

    return jsonResponse({
      payment: {
        id: payment.id,
        invoice_id: payment.invoice_id,
        status: payment.status,
        amount: Number(payment.amount),
        currency: payment.currency,
      },
      checkout: {
        payment_url: paymentUrl,
        cloudpayments_order_id: cloudPaymentsOrderId ?? null,
      },
    });
  } catch (error) {
    console.error("Unexpected create-payment error:", error);

    return jsonResponse({ error: "internal_server_error" }, 500);
  }
});