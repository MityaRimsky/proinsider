import { createClient } from "npm:@supabase/supabase-js@2";

type CloudPaymentsPayload = Record<string, unknown>;

type PaymentStatus =
  | "pending"
  | "authorized"
  | "paid"
  | "failed"
  | "cancelled"
  | "refunded";

type SubscriptionOptionRow = {
  id: number;
  plan_id: number;
  price: number | string;
  quantity: number;
  unit_type: "forecast" | "week" | "month";
  bonus_until_win?: boolean | null;
};

type PaymentRow = {
  id: number;
  user_id: string;
  option_id: number;
  status: PaymentStatus;
  amount: number | string;
  currency: string;
  payment_type: "one_time" | "subscription_initial" | "subscription_recurring";
  parent_payment_id: number | null;
  subscription_options: SubscriptionOptionRow | SubscriptionOptionRow[] | null;
};

type LiveSubscriptionRow = {
  id: number;
  user_id: string;
  plan_id: number;
  option_id: number;
  payment_id: number;
  status: "active" | "past_due" | "cancelled" | "expired";
  expires_at: string;
  provider: string;
  provider_subscription_id: string | null;
};

function okResponse(): Response {
  return new Response(JSON.stringify({ code: 0 }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
}

function errorResponse(message: string, status = 200): Response {
  /*
   * CloudPayments ожидает HTTP 200 + code != 0 для бизнес-ошибок.
   * HTTP 4xx/5xx оставляем только для ситуаций, где запрос совсем невалиден.
   */
  return new Response(JSON.stringify({ code: 13, message }), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

function normalizeHeader(headers: Headers, name: string): string | null {
  return headers.get(name) ?? headers.get(name.toLowerCase());
}

async function parsePayload(req: Request): Promise<CloudPaymentsPayload> {
  const contentType = req.headers.get("Content-Type") ?? "";

  if (contentType.includes("application/json")) {
    return await req.json();
  }

  const formData = await req.formData();
  const payload: CloudPaymentsPayload = {};

  for (const [key, value] of formData.entries()) {
    payload[key] = typeof value === "string" ? value : value.name;
  }

  return payload;
}

function getString(payload: CloudPaymentsPayload, keys: string[]): string | null {
  for (const key of keys) {
    const value = payload[key];

    if (value === null || value === undefined || value === "") {
      continue;
    }

    return String(value);
  }

  return null;
}

function getNumber(payload: CloudPaymentsPayload, keys: string[]): number | null {
  const value = getString(payload, keys);

  if (!value) {
    return null;
  }

  const numberValue = Number(value.replace(",", "."));

  return Number.isFinite(numberValue) ? numberValue : null;
}

function getBoolean(payload: CloudPaymentsPayload, keys: string[]): boolean | null {
  const value = getString(payload, keys);

  if (!value) {
    return null;
  }

  switch (value.trim().toLowerCase()) {
    case "true":
    case "1":
    case "yes":
    case "y":
      return true;
    case "false":
    case "0":
    case "no":
    case "n":
      return false;
    default:
      return null;
  }
}

function getEventType(req: Request): string {
  const eventType = new URL(req.url).searchParams
    .get("event")
    ?.trim()
    .toLowerCase();

  const allowedEvents = [
    "check",
    "pay",
    "fail",
    "confirm",
    "cancel",
    "refund",
    "recurrent",
  ];

  return eventType && allowedEvents.includes(eventType)
    ? eventType
    : "unknown";
}

function mapPaymentStatus(eventType: string): {
  status: "authorized" | "paid" | "failed" | "cancelled" | "refunded" | null;
  timestampColumn?: "paid_at" | "failed_at" | "refunded_at";
} {
  switch (eventType) {
    case "check":
      return { status: null };
    case "pay":
      return { status: "paid", timestampColumn: "paid_at" };
    case "confirm":
      return { status: "paid", timestampColumn: "paid_at" };
    case "auth":
      return { status: "authorized" };
    case "fail":
      return { status: "failed", timestampColumn: "failed_at" };
    case "cancel":
      return { status: "cancelled", timestampColumn: "failed_at" };
    case "refund":
      return { status: "refunded", timestampColumn: "refunded_at" };
    default:
      return { status: null };
  }
}

function mapRecurrentStatus(
  status: string | null,
): "active" | "past_due" | "cancelled" | null {
  switch ((status ?? "").toLowerCase()) {
    case "active":
      return "active";
    case "pastdue":
    case "past_due":
      return "past_due";
    case "cancelled":
    case "canceled":
      return "cancelled";
    default:
      return null;
  }
}

function buildIdempotencyKey(
  eventType: string,
  invoiceId: string | null,
  transactionId: number | null,
  payload: CloudPaymentsPayload,
): string {
  const payloadId = getString(payload, ["Id", "id", "EventId", "event_id"]);

  return [eventType, payloadId, transactionId, invoiceId]
    .filter((value) => value !== null && value !== undefined && value !== "")
    .join(":");
}

function normalizeOption(
  option: SubscriptionOptionRow | SubscriptionOptionRow[] | null,
): SubscriptionOptionRow | null {
  return Array.isArray(option) ? option[0] ?? null : option;
}

function moneyEquals(left: number | string, right: number): boolean {
  return Math.round(Number(left) * 100) === Math.round(right * 100);
}

function addEntitlementPeriod(fromIso: string | null, quantity: number, unitType: string): string {
  const now = new Date();
  const base = fromIso && new Date(fromIso) > now ? new Date(fromIso) : now;

  if (unitType === "week") {
    base.setUTCDate(base.getUTCDate() + 7 * quantity);
  } else if (unitType === "month") {
    base.setUTCMonth(base.getUTCMonth() + quantity);
  }

  return base.toISOString();
}

function shouldGrantEntitlement(
  eventType: string,
  previousPaymentStatus: PaymentStatus,
  mappedStatus: PaymentStatus | null,
): boolean {
  return eventType === "pay" && mappedStatus === "paid" && previousPaymentStatus !== "paid";
}

async function markWebhookEvent(
  admin: ReturnType<typeof createClient>,
  webhookEventId: number,
  status: "processed" | "failed" | "ignored",
  errorMessage?: string,
): Promise<void> {
  const update: Record<string, unknown> = {
    status,
    processed_at: new Date().toISOString(),
  };

  if (errorMessage !== undefined) {
    update.error_message = errorMessage;
  }

  const { error } = await admin
    .from("webhook_events")
    .update(update)
    .eq("id", webhookEventId);

  if (error) {
    console.error("Failed to mark webhook event:", error);
  }
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return errorResponse("method_not_allowed", 405);
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const expectedTestMode = (Deno.env.get("CLOUDPAYMENTS_EXPECT_TEST_MODE") ?? "false")
      .trim()
      .toLowerCase() === "true";

    if (!supabaseUrl || !serviceRoleKey) {
      console.error("Required environment variables are missing");

      return errorResponse("server_configuration_error", 500);
    }

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });

    const payload = await parsePayload(req);

    console.log("HEADERS:", Object.fromEntries(req.headers.entries()));
    console.log("PAYLOAD:", payload);
    
    const eventType = getEventType(req);
    const invoiceId = getString(payload, ["InvoiceId", "invoiceId", "invoice_id"]);
    const transactionId = getNumber(payload, [
      "TransactionId",
      "transactionId",
      "provider_transaction_id",
    ]);
    const amount = getNumber(payload, ["Amount", "amount"]);
    const accountId = getString(payload, ["AccountId", "accountId", "account_id"]);
    const testMode = getBoolean(payload, ["TestMode", "testMode", "test_mode"]);
    const subscriptionId = getString(payload, [
      "SubscriptionId",
      "subscriptionId",
      "provider_subscription_id",
    ]);
    const recurrentProviderSubscriptionId = getString(payload, ["Id", "id"]);
    const idempotencyKey = buildIdempotencyKey(
      eventType,
      invoiceId,
      transactionId,
      payload,
    );

    if (!idempotencyKey) {
      return errorResponse("missing_idempotency_key");
    }

    const { data: existingEvent, error: existingEventError } = await admin
      .from("webhook_events")
      .select("id, status")
      .eq("provider", "cloudpayments")
      .eq("idempotency_key", idempotencyKey)
      .maybeSingle();

    if (existingEventError) {
      console.error("Failed to check webhook idempotency:", existingEventError);

      return errorResponse("database_error");
    }

    if (existingEvent?.status === "processed" || existingEvent?.status === "ignored") {
      return okResponse();
    }

    if (eventType === "recurrent") {
      const recurrentStatus = mapRecurrentStatus(getString(payload, ["Status", "status"]));
      const { data: webhookEvent, error: webhookEventError } = await admin
        .from("webhook_events")
        .upsert(
          {
            provider: "cloudpayments",
            event_type: eventType,
            idempotency_key: idempotencyKey,
            payment_id: null,
            invoice_id: invoiceId,
            provider_transaction_id: transactionId,
            provider_subscription_id: recurrentProviderSubscriptionId,
            status: "processing",
            payload,
            error_message: null,
          },
          { onConflict: "provider,idempotency_key" },
        )
        .select("id")
        .single();

      if (webhookEventError) {
        console.error("Failed to save recurrent webhook event:", webhookEventError);

        return errorResponse("database_error");
      }

      if (!recurrentProviderSubscriptionId || !recurrentStatus) {
        await markWebhookEvent(
          admin,
          webhookEvent.id,
          "ignored",
          "Missing recurrent Id or unsupported Status",
        );

        return okResponse();
      }

      const { error: subscriptionUpdateError } = await admin
        .from("user_live_subscriptions")
        .update({ status: recurrentStatus })
        .eq("provider", "cloudpayments")
        .eq("provider_subscription_id", recurrentProviderSubscriptionId);

      if (subscriptionUpdateError) {
        console.error("Failed to update recurrent subscription status:", subscriptionUpdateError);

        await markWebhookEvent(admin, webhookEvent.id, "failed", subscriptionUpdateError.message);

        return errorResponse("subscription_update_failed");
      }

      await markWebhookEvent(admin, webhookEvent.id, "processed");

      return okResponse();
    }

    const paymentSelect = `
      id,
      user_id,
      option_id,
      status,
      amount,
      currency,
      payment_type,
      parent_payment_id,
      subscription_options (
        id,
        plan_id,
        price,
        quantity,
        unit_type,
        bonus_until_win
      )
    `;

    let payment: PaymentRow | null = null;

    if (invoiceId) {
      const { data: paymentByInvoice, error: paymentError } = await admin
        .from("payments")
        .select(paymentSelect)
        .eq("invoice_id", invoiceId)
        .maybeSingle();

      if (paymentError) {
        console.error("Failed to find payment:", paymentError);

        return errorResponse("database_error");
      }

      payment = paymentByInvoice as PaymentRow | null;
    }

    if (!payment && transactionId) {
      const { data: paymentByTransaction, error: paymentError } = await admin
        .from("payments")
        .select(paymentSelect)
        .eq("provider_transaction_id", transactionId)
        .maybeSingle();

      if (paymentError) {
        console.error("Failed to find payment by provider_transaction_id:", paymentError);

        return errorResponse("database_error");
      }

      payment = paymentByTransaction as PaymentRow | null;
    }

    let recurringSubscription: LiveSubscriptionRow | null = null;

    if (!payment && eventType === "pay" && subscriptionId) {
      const { data: existingSubscription, error: subscriptionError } = await admin
        .from("user_live_subscriptions")
        .select(`
          id,
          user_id,
          plan_id,
          option_id,
          payment_id,
          status,
          expires_at,
          provider,
          provider_subscription_id
        `)
        .eq("provider", "cloudpayments")
        .eq("provider_subscription_id", subscriptionId)
        .maybeSingle();

      if (subscriptionError) {
        console.error("Failed to find recurring subscription:", subscriptionError);

        return errorResponse("database_error");
      }

      recurringSubscription = existingSubscription as LiveSubscriptionRow | null;
    }

    if (!payment && eventType === "pay" && subscriptionId && recurringSubscription && transactionId) {
      const { data: initialPayment, error: initialPaymentError } = await admin
        .from("payments")
        .select(paymentSelect)
        .eq("id", recurringSubscription.payment_id)
        .maybeSingle();

      if (initialPaymentError) {
        console.error("Failed to find initial recurring payment:", initialPaymentError);

        return errorResponse("database_error");
      }

      const initialPaymentRow = initialPayment as PaymentRow | null;
      const fallbackInvoiceId = invoiceId || `cp_recurring_${transactionId}`;
      const fallbackIsValid = Boolean(
        initialPaymentRow &&
          amount !== null &&
          moneyEquals(initialPaymentRow.amount, amount) &&
          accountId === recurringSubscription.user_id &&
          testMode === expectedTestMode,
      );

      if (fallbackIsValid) {
        const { data: createdPayment, error: createPaymentError } = await admin
          .from("payments")
          .insert({
            user_id: recurringSubscription.user_id,
            option_id: recurringSubscription.option_id,
            provider: "cloudpayments",
            status: "pending",
            amount,
            currency: initialPaymentRow!.currency,
            invoice_id: fallbackInvoiceId,
            provider_transaction_id: transactionId,
            payment_type: "subscription_recurring",
            parent_payment_id: initialPaymentRow!.id,
            provider_payload: payload,
          })
          .select(paymentSelect)
          .single();

        if (createPaymentError) {
          console.error("Failed to create fallback recurring payment:", createPaymentError);

          return errorResponse("recurring_payment_creation_failed");
        }

        payment = createdPayment as PaymentRow;
      }
    }

    const eventValues = {
      provider: "cloudpayments",
      event_type: eventType,
      idempotency_key: idempotencyKey,
      payment_id: payment?.id ?? null,
      invoice_id: invoiceId,
      provider_transaction_id: transactionId,
      provider_subscription_id: subscriptionId,
      status: "processing",
      payload,
      error_message: null,
    };

    const { data: webhookEvent, error: webhookEventError } = await admin
      .from("webhook_events")
      .upsert(eventValues, {
        onConflict: "provider,idempotency_key",
      })
      .select("id")
      .single();

    if (webhookEventError) {
      console.error("Failed to save webhook event:", webhookEventError);

      return errorResponse("database_error");
    }

    if (!payment) {
      const isMissingFail = eventType === "fail";

      await markWebhookEvent(
        admin,
        webhookEvent.id,
        isMissingFail ? "ignored" : "failed",
        "Payment was not found and fallback recurring payment was not created",
      );

      return isMissingFail ? okResponse() : errorResponse("payment_not_found");
    }

    const mappedStatus = mapPaymentStatus(eventType);

    if (!mappedStatus.status) {
      await markWebhookEvent(admin, webhookEvent.id, "processed");

      return okResponse();
    }

    const previousPaymentStatus = payment.status;
    const now = new Date().toISOString();
    const paymentUpdate: Record<string, unknown> = {
      status: mappedStatus.status,
      provider_payload: payload,
    };

    if (transactionId) {
      paymentUpdate.provider_transaction_id = transactionId;
    }

    if (mappedStatus.timestampColumn) {
      paymentUpdate[mappedStatus.timestampColumn] = now;
    }

    if (mappedStatus.status === "failed" || mappedStatus.status === "cancelled") {
      paymentUpdate.failure_code = getString(payload, ["ReasonCode", "reasonCode"]);
      paymentUpdate.failure_message = getString(payload, ["Reason", "reason"]);
    }

    const { error: updatePaymentError } = await admin
      .from("payments")
      .update(paymentUpdate)
      .eq("id", payment.id);

    if (updatePaymentError) {
      console.error("Failed to update payment:", updatePaymentError);

      await markWebhookEvent(admin, webhookEvent.id, "failed", updatePaymentError.message);

      return errorResponse("payment_update_failed");
    }

    if (shouldGrantEntitlement(eventType, previousPaymentStatus, mappedStatus.status)) {
      const option = normalizeOption(payment.subscription_options);

      if (!option) {
        await markWebhookEvent(
          admin,
          webhookEvent.id,
          "failed",
          "Subscription option was not found for entitlement grant",
        );

        return errorResponse("option_not_found");
      }

      if (amount === null || !moneyEquals(payment.amount, amount)) {
        await markWebhookEvent(admin, webhookEvent.id, "failed", "Amount validation failed");

        return errorResponse("amount_validation_failed");
      }

      if (accountId !== payment.user_id) {
        await markWebhookEvent(admin, webhookEvent.id, "failed", "AccountId validation failed");

        return errorResponse("account_validation_failed");
      }

      if (testMode !== expectedTestMode) {
        await markWebhookEvent(admin, webhookEvent.id, "failed", "TestMode validation failed");

        return errorResponse("test_mode_validation_failed");
      }

      if (option.unit_type === "forecast") {
        const { error: creditError } = await admin
          .from("user_forecast_credits")
          .insert({
            user_id: payment.user_id,
            plan_id: option.plan_id,
            option_id: option.id,
            payment_id: payment.id,
            quantity_granted: option.quantity,
            bonus_until_win: option.bonus_until_win === true,
          });

        if (creditError && creditError.code !== "23505") {
          console.error("Failed to grant forecast credits:", creditError);

          await markWebhookEvent(admin, webhookEvent.id, "failed", creditError.message);

          return errorResponse("forecast_entitlement_failed");
        }
      } else if (option.unit_type === "week" || option.unit_type === "month") {
        const expiresAt = addEntitlementPeriod(
          recurringSubscription?.expires_at ?? null,
          option.quantity,
          option.unit_type,
        );

        if (payment.payment_type === "subscription_recurring" && recurringSubscription) {
          const { error: subscriptionExtendError } = await admin
            .from("user_live_subscriptions")
            .update({
              status: "active",
              expires_at: expiresAt,
            })
            .eq("id", recurringSubscription.id);

          if (subscriptionExtendError) {
            console.error("Failed to extend live subscription:", subscriptionExtendError);

            await markWebhookEvent(admin, webhookEvent.id, "failed", subscriptionExtendError.message);

            return errorResponse("live_subscription_extension_failed");
          }
        } else {
          const { error: subscriptionError } = await admin
            .from("user_live_subscriptions")
            .insert({
              user_id: payment.user_id,
              plan_id: option.plan_id,
              option_id: option.id,
              payment_id: payment.id,
              status: "active",
              starts_at: now,
              expires_at: expiresAt,
              provider: "cloudpayments",
              provider_subscription_id: subscriptionId,
            });

          if (subscriptionError && subscriptionError.code !== "23505") {
            console.error("Failed to grant live subscription:", subscriptionError);

            await markWebhookEvent(admin, webhookEvent.id, "failed", subscriptionError.message);

            return errorResponse("live_subscription_entitlement_failed");
          }
        }
      }
    }

    const { error: updateEventError } = await admin
      .from("webhook_events")
      .update({
        status: "processed",
        processed_at: now,
      })
      .eq("id", webhookEvent.id);

    if (updateEventError) {
      console.error("Failed to mark webhook event as processed:", updateEventError);
    }

    return okResponse();
  } catch (error) {
    console.error("Unexpected CloudPayments webhook error:", error);

    return errorResponse("internal_server_error", 500);
  }
});