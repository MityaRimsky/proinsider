/*
 * pg_net -> send-push authorization:
 * - FUNCTIONS_VERIFY_JWT=false makes Edge Functions callable without JWT.
 * - send-push performs its own Authorization: Bearer service-role check.
 * - The service role key is read from Supabase Vault and is not hardcoded here.
 *
 * Before applying/using this migration in production, store the key once:
 * select vault.create_secret('REAL_SERVICE_ROLE_KEY_HERE', 'supabase_service_role_key');
 */

create schema if not exists vault;
create extension if not exists supabase_vault with schema vault;
create extension if not exists pg_net with schema extensions;

create or replace function public.invoke_send_push_forecast(
  p_type text,
  p_forecast_card_id bigint
)
returns void
language plpgsql
security definer
set search_path = public, net, extensions, pg_temp
as $$
declare
  v_service_role_key text;
begin
  if p_type not in ('premium', 'gold') then
    return;
  end if;

  select decrypted_secret
  into v_service_role_key
  from vault.decrypted_secrets
  where name = 'supabase_service_role_key'
  limit 1;

  if nullif(v_service_role_key, '') is null then
    raise warning 'Vault secret supabase_service_role_key is missing; push skipped';
    return;
  end if;

  perform net.http_post(
    url := 'http://kong:8000/functions/v1/send-push',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || v_service_role_key
    ),
    body := jsonb_build_object(
      'type', p_type,
      'forecast_card_id', p_forecast_card_id
    )
  );
end;
$$;

create or replace function public.invoke_send_push_live(
  p_live_prediction_id bigint
)
returns void
language plpgsql
security definer
set search_path = public, net, extensions, pg_temp
as $$
declare
  v_service_role_key text;
begin
  select decrypted_secret
  into v_service_role_key
  from vault.decrypted_secrets
  where name = 'supabase_service_role_key'
  limit 1;

  if nullif(v_service_role_key, '') is null then
    raise warning 'Vault secret supabase_service_role_key is missing; push skipped';
    return;
  end if;

  perform net.http_post(
    url := 'http://kong:8000/functions/v1/send-push',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || v_service_role_key
    ),
    body := jsonb_build_object(
      'type', 'live',
      'live_prediction_id', p_live_prediction_id
    )
  );
end;
$$;

create or replace function public.on_forecast_created()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if new.type not in ('premium', 'gold') then
    return new;
  end if;

  perform public.create_forecast_notification(new.id);
  perform public.distribute_forecast(new.id);

  /*
   * One async pg_net call per forecast, after user_forecast_assignments exist.
   * Do not move this before distribute_forecast(), otherwise send-push can see
   * zero assigned users.
   */
  perform public.invoke_send_push_forecast(new.type, new.id);

  return new;
end;
$$;

create or replace function public.create_live_prediction_notification()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_notification_id bigint;
begin
  insert into public.notifications (
    title,
    plan_type,
    forecast_card_id,
    match_time,
    coefficient
  )
  values (
    'Новый Live прогноз',
    'live',
    null,
    null,
    0
  )
  returning id into v_notification_id;

  insert into public.user_live_prediction_assignments (
    user_id,
    live_prediction_id,
    notification_id
  )
  select distinct
    s.user_id,
    new.id,
    v_notification_id
  from public.user_live_subscriptions s
  join public.subscription_plans p
    on p.id = s.plan_id
  where p.name = 'live'
    and s.status in ('active', 'past_due', 'cancelled')
    and coalesce(new.published_at, now()) >= s.starts_at
    and coalesce(new.published_at, now()) <= s.expires_at
  on conflict (user_id, live_prediction_id)
  do update
  set notification_id = excluded.notification_id;

  /*
   * One async pg_net call per live prediction, after all
   * user_live_prediction_assignments exist.
   */
  perform public.invoke_send_push_live(new.id);

  return new;
end;
$$;

revoke execute on function public.invoke_send_push_forecast(text, bigint)
from public, anon, authenticated;

revoke execute on function public.invoke_send_push_live(bigint)
from public, anon, authenticated;

revoke execute on function public.on_forecast_created()
from public, anon, authenticated;

revoke execute on function public.create_live_prediction_notification()
from public, anon, authenticated;
