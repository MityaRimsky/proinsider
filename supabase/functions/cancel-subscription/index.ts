import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type CloudPaymentsCancelResponse = {
  Success?: boolean;
  Message?: string | null;
  Model?: unknown;
};

type LiveSubscriptionRow = {
  id: number;
  user_id: string;
  status: "active" | "past_due" | "cancelled" | "expired";
  expires_at: string;
  provider: string;
  provider_subscription_id: string | null;
  created_at: string;
};

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

    if (!accessToken) {
      return jsonResponse({ error: "unauthorized" }, 401);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const cloudPaymentsPublicId = Deno.env.get("CLOUDPAYMENTS_PUBLIC_ID");
    const cloudPaymentsApiSecret = Deno.env.get("CLOUDPAYMENTS_API_SECRET");

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
     * Service role используется только внутри Edge Function.
     * user_id из клиента не принимаем и не используем.
     */
    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });

    /*
     * Пользователя определяем исключительно по JWT.
     */
    const {
      data: { user },
      error: userError,
    } = await admin.auth.getUser(accessToken);

    if (userError || !user) {
      console.error("User authentication failed:", userError);

      return jsonResponse({ error: "unauthorized" }, 401);
    }

    /*
     * В системе существует только одна рекуррентная подписка — Live.
     * cancelled включён для идемпотентного повторного вызова.
     */
    const { data: subscriptionData, error: subscriptionError } = await admin
      .from("user_live_subscriptions")
      .select(`
        id,
        user_id,
        status,
        expires_at,
        provider,
        provider_subscription_id,
        created_at
      `)
      .eq("user_id", user.id)
      .eq("provider", "cloudpayments")
      .in("status", ["active", "past_due", "cancelled"])
      .order("expires_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (subscriptionError) {
      console.error("Failed to read user subscription:", subscriptionError);

      return jsonResponse({ error: "database_error" }, 500);
    }

    const subscription = subscriptionData as LiveSubscriptionRow | null;

    if (!subscription) {
      return jsonResponse(
        {
          error: "subscription_not_found",
          message: "Активная Live-подписка не найдена",
        },
        404,
      );
    }

    if (subscription.status === "cancelled") {
      return jsonResponse({
        success: true,
        status: "cancelled",
        already_cancelled: true,
        subscription_id: subscription.id,
        provider_subscription_id: subscription.provider_subscription_id,
        access_until: subscription.expires_at,
        message:
          "Автоматическое продление уже отключено. Доступ сохранён до окончания оплаченного периода.",
      });
    }

    if (!subscription.provider_subscription_id) {
      console.error("Provider subscription ID is missing:", subscription.id);

      return jsonResponse(
        {
          error: "provider_subscription_id_missing",
          message: "У Live-подписки отсутствует идентификатор CloudPayments",
        },
        409,
      );
    }

    let cloudPaymentsResponse: Response;

    try {
      cloudPaymentsResponse = await fetch(
        "https://api.cloudpayments.ru/subscriptions/cancel",
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
          body: JSON.stringify({
            Id: subscription.provider_subscription_id,
          }),
        },
      );
    } catch (error) {
      console.error("CloudPayments connection error:", error);

      return jsonResponse(
        {
          error: "cloudpayments_unavailable",
          message: "Не удалось соединиться с CloudPayments",
        },
        502,
      );
    }

    const responseText = await cloudPaymentsResponse.text();
    let cloudPaymentsResult: CloudPaymentsCancelResponse;

    try {
      cloudPaymentsResult = JSON.parse(responseText);
    } catch {
      console.error(
        "Invalid CloudPayments response:",
        cloudPaymentsResponse.status,
        responseText,
      );

      return jsonResponse(
        {
          error: "invalid_cloudpayments_response",
          message: "CloudPayments вернул некорректный ответ",
        },
        502,
      );
    }

    if (!cloudPaymentsResponse.ok || cloudPaymentsResult.Success !== true) {
      console.error(
        "CloudPayments rejected subscription cancellation:",
        cloudPaymentsResponse.status,
        cloudPaymentsResult,
      );

      return jsonResponse(
        {
          error: "cloudpayments_cancellation_failed",
          message:
            cloudPaymentsResult.Message ?? "CloudPayments не отменил подписку",
        },
        502,
      );
    }

    /*
     * CloudPayments подтвердил отмену автопродления.
     * expires_at не изменяем: доступ сохраняется до конца оплаченного периода.
     */
    const { error: updateError } = await admin
      .from("user_live_subscriptions")
      .update({
        status: "cancelled",
      })
      .eq("id", subscription.id)
      .eq("user_id", user.id)
      .in("status", ["active", "past_due"]);

    if (updateError) {
      console.error(
        "CloudPayments cancelled subscription, but database update failed:",
        updateError,
      );

      return jsonResponse({
        success: true,
        status: "cancelled",
        warning: "local_subscription_update_failed",
        message:
          "Автоматическое продление отменено, но локальный статус временно не обновился",
        subscription_id: subscription.id,
        provider_subscription_id: subscription.provider_subscription_id,
        access_until: subscription.expires_at,
      });
    }

    return jsonResponse({
      success: true,
      status: "cancelled",
      already_cancelled: false,
      subscription_id: subscription.id,
      provider_subscription_id: subscription.provider_subscription_id,
      access_until: subscription.expires_at,
      message:
        "Автоматическое продление отменено. Доступ сохранён до окончания оплаченного периода.",
    });
  } catch (error) {
    console.error("Unexpected cancel-subscription error:", error);

    return jsonResponse({ error: "internal_server_error" }, 500);
  }
});