import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
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

    const apikey = req.headers.get("apikey");
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      console.error("Required environment variables are missing");

      return jsonResponse(
        { error: "server_configuration_error" },
        500,
      );
    }

    /*
     * Service Role используется только внутри Edge Function.
     */
    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });

    /*
     * user_id из клиента не принимаем.
     * Определяем пользователя исключительно по JWT.
     */
    const {
      data: { user },
      error: userError,
    } = await admin.auth.getUser(accessToken);

    if (userError || !user) {
      console.error("User authentication failed:", userError);

      return jsonResponse({ error: "unauthorized" }, 401);
    }

    const userId = user.id;

    /*
     * Проверяем, существует ли у пользователя Live-подписка
     * CloudPayments, которую потенциально нужно отменить.
     *
     * Саму логику отмены здесь НЕ дублируем.
     */
    const { data: liveSubscription, error: liveError } = await admin
      .from("user_live_subscriptions")
      .select("id, status")
      .eq("user_id", userId)
      .eq("provider", "cloudpayments")
      .in("status", ["active", "past_due", "cancelled"])
      .order("expires_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (liveError) {
      console.error(
        "Failed to check Live subscription:",
        liveError,
      );

      return jsonResponse({ error: "database_error" }, 500);
    }

    /*
     * Если Live существует и ещё не cancelled,
     * вызываем существующую cancel-subscription.
     */
    if (
      liveSubscription &&
      liveSubscription.status !== "cancelled"
    ) {
      let cancelResponse: Response;

      try {
        cancelResponse = await fetch(
          `${supabaseUrl}/functions/v1/cancel-subscription`,
          {
            method: "POST",
            headers: {
              Authorization: authorization,
              "Content-Type": "application/json",
              ...(apikey ? { apikey } : {}),
            },
          },
        );
      } catch (error) {
        console.error(
          "Failed to call cancel-subscription:",
          error,
        );

        return jsonResponse(
          {
            error: "subscription_cancellation_unavailable",
            message:
              "Не удалось отменить автоматическое продление",
          },
          502,
        );
      }

      if (!cancelResponse.ok) {
        const responseText = await cancelResponse.text();

        console.error(
          "cancel-subscription failed:",
          cancelResponse.status,
          responseText,
        );

        /*
         * Если CloudPayments не подтвердил отмену,
         * аккаунт НЕ удаляем.
         */
        return jsonResponse(
          {
            error: "subscription_cancellation_failed",
            message:
              "Не удалось отменить автоматическое продление",
          },
          502,
        );
      }
    }

    /*
     * Удаляем ТОЛЬКО технические notification-данные.
     *
     * Никакие payments, balances, assignments,
     * bonuses, credits и subscription history
     * здесь не удаляются.
     */
    const { error: pushError } = await admin
      .from("user_push_tokens")
      .delete()
      .eq("user_id", userId);

    if (pushError) {
      console.error(
        "Failed to delete push tokens:",
        pushError,
      );

      return jsonResponse({ error: "database_error" }, 500);
    }

    const { error: preferencesError } = await admin
      .from("user_notification_preferences")
      .delete()
      .eq("user_id", userId);

    if (preferencesError) {
      console.error(
        "Failed to delete notification preferences:",
        preferencesError,
      );

      return jsonResponse({ error: "database_error" }, 500);
    }

    const { error: stateError } = await admin
      .from("user_notification_state")
      .delete()
      .eq("user_id", userId);

    if (stateError) {
      console.error(
        "Failed to delete notification state:",
        stateError,
      );

      return jsonResponse({ error: "database_error" }, 500);
    }

    /*
     * SOFT DELETE Supabase Auth пользователя.
     *
     * true = soft delete.
     *
     * auth.users физически не удаляется,
     * поэтому существующие FK/CASCADE бизнес-таблиц
     * не затрагиваются.
     */
    const { error: deleteUserError } =
      await admin.auth.admin.deleteUser(userId, true);

    if (deleteUserError) {
      console.error(
        "Failed to soft delete user:",
        deleteUserError,
      );

      return jsonResponse(
        {
          error: "account_deletion_failed",
          message: "Не удалось удалить аккаунт",
        },
        500,
      );
    }

    return jsonResponse({
      success: true,
    });
  } catch (error) {
    console.error(
      "Unexpected delete-account error:",
      error,
    );

    return jsonResponse(
      { error: "internal_server_error" },
      500,
    );
  }
});
