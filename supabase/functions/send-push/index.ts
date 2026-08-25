import { createClient } from "npm:@supabase/supabase-js@2";
import { GoogleAuth } from "npm:google-auth-library@9";

type PushRequest =
  | {
      type: "premium" | "gold";
      forecast_card_id: number;
    }
  | {
      type: "live";
      live_prediction_id: number;
    };

type PushTokenRow = {
  id: string;
  user_id: string;
  fcm_token: string;
  platform: "android" | "ios";
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(
  body: Record<string, unknown>,
  status = 200,
): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

function uniqueStrings(values: string[]): string[] {
  return [...new Set(values)];
}

function getBearerToken(req: Request): string | null {
  const authorization = req.headers.get("authorization");

  if (!authorization) {
    return null;
  }

  const match = authorization.match(/^Bearer\s+(.+)$/i);

  return match?.[1]?.trim() || null;
}

function isAuthorizedServiceRoleRequest(
  req: Request,
  serviceRoleKey: string,
): boolean {
  const bearerToken = getBearerToken(req);

  return bearerToken === serviceRoleKey;
}

function chunks<T>(items: T[], size: number): T[][] {
  const result: T[][] = [];

  for (let i = 0; i < items.length; i += size) {
    result.push(items.slice(i, i + size));
  }

  return result;
}

function isUnregisteredFcmResponse(
  status: number,
  responseText: string,
): boolean {
  if (status !== 404) {
    return false;
  }

  try {
    const parsed = JSON.parse(responseText);
    const details = parsed?.error?.details;

    if (Array.isArray(details)) {
      return details.some(
        (detail) =>
          detail?.errorCode === "UNREGISTERED" ||
          (detail?.["@type"] ===
              "type.googleapis.com/google.firebase.fcm.v1.FcmError" &&
            detail?.errorCode === "UNREGISTERED"),
      );
    }
  } catch {
    // Если ответ не JSON, просто не удаляем токен.
  }

  return responseText.includes("UNREGISTERED");
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  try {
    /*
     * --------------------------------------------------------
     * ENV
     * --------------------------------------------------------
     */

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    const firebaseProjectId = Deno.env.get("FIREBASE_PROJECT_ID");
    const firebaseClientEmail = Deno.env.get("FIREBASE_CLIENT_EMAIL");
    const firebasePrivateKeyRaw = Deno.env.get("FIREBASE_PRIVATE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      return jsonResponse(
        { error: "Supabase server variables are missing" },
        500,
      );
    }

    /*
     * FUNCTIONS_VERIFY_JWT=false отключает автоматическую проверку JWT
     * на уровне Edge Runtime. Поэтому защищаем этот service-to-service
     * endpoint вручную: pg_net должен вызывать его с
     * Authorization: Bearer <SUPABASE_SERVICE_ROLE_KEY>.
     *
     * Проверка выполняется до чтения body, создания Supabase client
     * и любой бизнес-логики.
     */
    if (!isAuthorizedServiceRoleRequest(req, serviceRoleKey)) {
      return jsonResponse({ error: "Unauthorized" }, 401);
    }

    if (
      !firebaseProjectId ||
      !firebaseClientEmail ||
      !firebasePrivateKeyRaw
    ) {
      return jsonResponse(
        { error: "Firebase server variables are missing" },
        500,
      );
    }

    const supabase = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });

    /*
     * --------------------------------------------------------
     * REQUEST
     * --------------------------------------------------------
     */

    let payload: PushRequest;

    try {
      payload = await req.json();
    } catch {
      return jsonResponse({ error: "Invalid JSON body" }, 400);
    }

    if (!payload || !["premium", "gold", "live"].includes(payload.type)) {
      return jsonResponse({ error: "Invalid push type" }, 400);
    }

    /*
     * --------------------------------------------------------
     * FIND USERS ASSIGNED TO THIS FORECAST
     * --------------------------------------------------------
     */

    let assignedUserIds: string[] = [];
    let title = "Proinsider";
    let messageBody = "Опубликован новый прогноз";
    let data: Record<string, string> = {
      type: payload.type,
    };

    if (payload.type === "premium" || payload.type === "gold") {
      const forecastCardId =
        "forecast_card_id" in payload ? Number(payload.forecast_card_id) : NaN;

      if (!Number.isInteger(forecastCardId) || forecastCardId <= 0) {
        return jsonResponse({ error: "forecast_card_id is required" }, 400);
      }

      /*
       * Получаем сам прогноз.
       * Заодно защищаемся от ситуации, когда передали
       * type=gold для premium-карточки или наоборот.
       */
      const { data: forecast, error: forecastError } = await supabase
        .from("forecast_cards")
        .select("id,type,total_odds,start_time")
        .eq("id", forecastCardId)
        .single();

      if (forecastError || !forecast) {
        console.error("send-push: forecast lookup failed", forecastError);

        return jsonResponse({ error: "Forecast not found" }, 404);
      }

      if (forecast.type !== payload.type) {
        return jsonResponse(
          {
            error: "Forecast type mismatch",
            expected: forecast.type,
            received: payload.type,
          },
          400,
        );
      }

      const { data: assignments, error: assignmentsError } = await supabase
        .from("user_forecast_assignments")
        .select("user_id")
        .eq("forecast_card_id", forecastCardId);

      if (assignmentsError) {
        console.error(
          "send-push: forecast assignments query failed",
          assignmentsError,
        );

        return jsonResponse(
          { error: "Could not load forecast assignments" },
          500,
        );
      }

      assignedUserIds = uniqueStrings(
        (assignments ?? []).map((row) => row.user_id),
      );

      const planName = payload.type === "premium" ? "Premium" : "Gold";

      title = `Новый ${planName} прогноз`;
      messageBody = "Новый прогноз доступен в приложении";
      data = {
        type: payload.type,
        forecast_card_id: String(forecastCardId),
      };
    } else {
      /*
       * LIVE
       */

      const livePredictionId =
        "live_prediction_id" in payload
          ? Number(payload.live_prediction_id)
          : NaN;

      if (!Number.isInteger(livePredictionId) || livePredictionId <= 0) {
        return jsonResponse({ error: "live_prediction_id is required" }, 400);
      }

      const { data: livePrediction, error: livePredictionError } =
        await supabase
          .from("live_predictions")
          .select("id,published_at")
          .eq("id", livePredictionId)
          .single();

      if (livePredictionError || !livePrediction) {
        console.error(
          "send-push: live prediction lookup failed",
          livePredictionError,
        );

        return jsonResponse({ error: "Live prediction not found" }, 404);
      }

      const { data: assignments, error: assignmentsError } = await supabase
        .from("user_live_prediction_assignments")
        .select("user_id")
        .eq("live_prediction_id", livePredictionId);

      if (assignmentsError) {
        console.error(
          "send-push: live assignments query failed",
          assignmentsError,
        );

        return jsonResponse(
          { error: "Could not load live assignments" },
          500,
        );
      }

      assignedUserIds = uniqueStrings(
        (assignments ?? []).map((row) => row.user_id),
      );

      title = "Новый Live прогноз";
      messageBody = "Новый Live прогноз доступен в приложении";
      data = {
        type: "live",
        live_prediction_id: String(livePredictionId),
      };
    }

    /*
     * Если distribute_forecast/create_live_prediction_notification
     * никому прогноз не назначили — это не ошибка.
     */
    if (assignedUserIds.length === 0) {
      return jsonResponse({
        ok: true,
        type: payload.type,
        assigned_users: 0,
        push_enabled_users: 0,
        tokens: 0,
        sent: 0,
        failed: 0,
        removed_tokens: 0,
      });
    }

    /*
     * --------------------------------------------------------
     * USER NOTIFICATION PREFERENCES
     * --------------------------------------------------------
     *
     * Chunk нужен, чтобы не строить огромный PostgREST URL
     * при большом количестве UUID.
     */

    const pushEnabledUserIds: string[] = [];

    for (const userIdsChunk of chunks(assignedUserIds, 100)) {
      const { data: preferences, error: preferencesError } = await supabase
        .from("user_notification_preferences")
        .select("user_id")
        .eq("push_enabled", true)
        .in("user_id", userIdsChunk);

      if (preferencesError) {
        console.error("send-push: preferences query failed", preferencesError);

        return jsonResponse({ error: "Could not load push preferences" }, 500);
      }

      pushEnabledUserIds.push(
        ...(preferences ?? []).map((row) => row.user_id),
      );
    }

    const enabledUserIds = uniqueStrings(pushEnabledUserIds);

    if (enabledUserIds.length === 0) {
      return jsonResponse({
        ok: true,
        type: payload.type,
        assigned_users: assignedUserIds.length,
        push_enabled_users: 0,
        tokens: 0,
        sent: 0,
        failed: 0,
        removed_tokens: 0,
      });
    }

    /*
     * --------------------------------------------------------
     * FCM TOKENS
     * --------------------------------------------------------
     */

    const pushTokens: PushTokenRow[] = [];

    for (const userIdsChunk of chunks(enabledUserIds, 100)) {
      const { data: tokenRows, error: tokenError } = await supabase
        .from("user_push_tokens")
        .select("id,user_id,fcm_token,platform")
        .in("user_id", userIdsChunk);

      if (tokenError) {
        console.error("send-push: token query failed", tokenError);

        return jsonResponse({ error: "Could not load push tokens" }, 500);
      }

      pushTokens.push(...((tokenRows ?? []) as PushTokenRow[]));
    }

    /*
     * На всякий случай исключаем возможные дубли одного
     * и того же FCM-токена.
     */

    const uniqueTokenMap = new Map<string, PushTokenRow>();

    for (const tokenRow of pushTokens) {
      if (tokenRow.fcm_token && !uniqueTokenMap.has(tokenRow.fcm_token)) {
        uniqueTokenMap.set(tokenRow.fcm_token, tokenRow);
      }
    }

    const tokens = [...uniqueTokenMap.values()];

    if (tokens.length === 0) {
      return jsonResponse({
        ok: true,
        type: payload.type,
        assigned_users: assignedUserIds.length,
        push_enabled_users: enabledUserIds.length,
        tokens: 0,
        sent: 0,
        failed: 0,
        removed_tokens: 0,
      });
    }

    /*
     * --------------------------------------------------------
     * FIREBASE OAUTH
     * --------------------------------------------------------
     */

    const firebasePrivateKey = firebasePrivateKeyRaw.replace(/\\n/g, "\n");

    const auth = new GoogleAuth({
      credentials: {
        project_id: firebaseProjectId,
        client_email: firebaseClientEmail,
        private_key: firebasePrivateKey,
      },
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });

    const googleClient = await auth.getClient();
    const accessTokenResponse = await googleClient.getAccessToken();
    const accessToken = accessTokenResponse.token;

    if (!accessToken) {
      return jsonResponse(
        { error: "Could not obtain Firebase access token" },
        500,
      );
    }

    /*
     * --------------------------------------------------------
     * SEND
     * --------------------------------------------------------
     *
     * HTTP v1 /messages:send отправляет сообщение конкретному
     * registration token.
     *
     * Отправляем небольшими параллельными пачками, чтобы не
     * создавать огромный burst запросов.
     */

    let sent = 0;
    let failed = 0;
    const invalidTokenIds: string[] = [];
    const tokenBatches = chunks(tokens, 25);

    for (const tokenBatch of tokenBatches) {
      const results = await Promise.all(
        tokenBatch.map(async (tokenRow) => {
          try {
            const response = await fetch(
              `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`,
              {
                method: "POST",
                headers: {
                  Authorization: `Bearer ${accessToken}`,
                  "Content-Type": "application/json",
                },
                body: JSON.stringify({
                  message: {
                    token: tokenRow.fcm_token,
                    notification: {
                      title,
                      body: messageBody,
                    },
                    data,
                    android: {
                      priority: "high",
                      notification: {
                        sound: "default",
                      },
                    },
                    apns: {
                      headers: {
                        "apns-priority": "10",
                      },
                      payload: {
                        aps: {
                          sound: "default",
                        },
                      },
                    },
                  },
                }),
              },
            );

            const responseText = await response.text();

            if (response.ok) {
              return {
                success: true,
                invalid: false,
              };
            }

            const invalid = isUnregisteredFcmResponse(
              response.status,
              responseText,
            );

            console.error("send-push: FCM send failed", {
              status: response.status,
              platform: tokenRow.platform,
              invalid,
              response: responseText,
            });

            return {
              success: false,
              invalid,
            };
          } catch (error) {
            console.error("send-push: FCM request exception", {
              platform: tokenRow.platform,
              error: String(error),
            });

            return {
              success: false,
              invalid: false,
            };
          }
        }),
      );

      results.forEach((result, index) => {
        const tokenRow = tokenBatch[index];

        if (result.success) {
          sent += 1;
        } else {
          failed += 1;
        }

        if (result.invalid) {
          invalidTokenIds.push(tokenRow.id);
        }
      });
    }

    /*
     * --------------------------------------------------------
     * REMOVE INVALID FCM TOKENS
     * --------------------------------------------------------
     *
     * UNREGISTERED означает, что registration token больше
     * нельзя использовать.
     */

    if (invalidTokenIds.length > 0) {
      for (const invalidIdsChunk of chunks(invalidTokenIds, 100)) {
        const { error: deleteError } = await supabase
          .from("user_push_tokens")
          .delete()
          .in("id", invalidIdsChunk);

        if (deleteError) {
          /*
           * Не считаем всю отправку неуспешной:
           * сообщения уже были отправлены.
           */
          console.error(
            "send-push: failed to delete invalid tokens",
            deleteError,
          );
        }
      }
    }

    /*
     * --------------------------------------------------------
     * RESULT
     * --------------------------------------------------------
     */

    return jsonResponse({
      ok: true,
      type: payload.type,
      assigned_users: assignedUserIds.length,
      push_enabled_users: enabledUserIds.length,
      tokens: tokens.length,
      sent,
      failed,
      removed_tokens: invalidTokenIds.length,
    });
  } catch (error) {
    console.error("send-push: unexpected error", error);

    return jsonResponse({ error: "Internal server error" }, 500);
  }
});
