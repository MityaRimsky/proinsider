create unique index if not exists idx_notifications_forecast_card_id_unique
  on public.notifications(forecast_card_id)
  where forecast_card_id is not null;

create index if not exists idx_subscription_plans_name_normalized
  on public.subscription_plans((lower(trim(name))));

create or replace function public.assign_forecast_to_user(
  p_user_id uuid,
  p_forecast_card_id bigint,
  p_plan_id bigint
)
returns bigint
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_credit_id bigint;
  v_bonus_id bigint;
  v_assignment_id bigint;
begin
  /*
   * Баланс общий для пользователя и плана, поэтому блокируем именно
   * пару user_id + plan_id, а не user_id + forecast_card_id.
   */
  perform pg_advisory_xact_lock(
    hashtextextended(
      p_user_id::text || ':' || p_plan_id::text,
      0
    )
  );

  select a.id
    into v_assignment_id
  from public.user_forecast_assignments a
  where a.user_id = p_user_id
    and a.forecast_card_id = p_forecast_card_id;

  if v_assignment_id is not null then
    return v_assignment_id;
  end if;

  /*
   * Сначала списываем бонусный кредит, если он есть.
   * Это продолжает цепочку "до первого выигрыша" до новых покупок.
   */
  select b.id
    into v_bonus_id
  from public.user_forecast_bonuses b
  join public.user_forecast_credits source_credit
    on source_credit.id = b.source_credit_id
  where b.user_id = p_user_id
    and source_credit.plan_id = p_plan_id
    and b.quantity_used < b.quantity_granted
  order by b.created_at, b.id
  limit 1
  for update of b skip locked;

  if v_bonus_id is not null then
    update public.user_forecast_bonuses
    set
      quantity_used = quantity_used + 1,
      updated_at = now()
    where id = v_bonus_id;

    insert into public.user_forecast_assignments (
      user_id,
      forecast_card_id,
      credit_id,
      bonus_id,
      bonus_granted
    )
    values (
      p_user_id,
      p_forecast_card_id,
      null,
      v_bonus_id,
      false
    )
    returning id into v_assignment_id;

    return v_assignment_id;
  end if;

  select c.id
    into v_credit_id
  from public.user_forecast_credits c
  where c.user_id = p_user_id
    and c.plan_id = p_plan_id
    and c.quantity_used < c.quantity_granted
  order by c.created_at, c.id
  limit 1
  for update skip locked;

  if v_credit_id is not null then
    update public.user_forecast_credits
    set
      quantity_used = quantity_used + 1,
      updated_at = now()
    where id = v_credit_id;

    insert into public.user_forecast_assignments (
      user_id,
      forecast_card_id,
      credit_id,
      bonus_id,
      bonus_granted
    )
    values (
      p_user_id,
      p_forecast_card_id,
      v_credit_id,
      null,
      false
    )
    returning id into v_assignment_id;

    return v_assignment_id;
  end if;

  return null;
end;
$$;

create or replace function public.create_forecast_notification(
  p_forecast_card_id bigint
)
returns bigint
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_forecast public.forecast_cards%rowtype;
  v_notification_id bigint;
begin
  select *
    into v_forecast
  from public.forecast_cards
  where id = p_forecast_card_id;

  if not found then
    raise exception 'Forecast card with id % not found', p_forecast_card_id;
  end if;

  if v_forecast.type not in ('premium', 'gold') then
    return null;
  end if;

  insert into public.notifications (
    title,
    message,
    plan_type,
    forecast_card_id
  )
  values (
    'Новый ' || initcap(v_forecast.type) || ' прогноз',
    to_char(v_forecast.start_time at time zone 'Europe/Moscow', 'HH24:MI')
      || ' | Общий КФ: '
      || v_forecast.total_odds::text,
    v_forecast.type,
    v_forecast.id
  )
  on conflict (forecast_card_id)
  where forecast_card_id is not null
  do nothing
  returning id into v_notification_id;

  if v_notification_id is null then
    select n.id
      into v_notification_id
    from public.notifications n
    where n.forecast_card_id = p_forecast_card_id;
  end if;

  return v_notification_id;
end;
$$;

create or replace function public.assign_latest_forecast_to_credit()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_plan_name text;
  v_forecast_card_id bigint;
begin
  select sp.name
    into v_plan_name
  from public.subscription_plans sp
  where sp.id = new.plan_id;

  if v_plan_name is null then
    return new;
  end if;

  v_plan_name := lower(trim(v_plan_name));

  if v_plan_name not in ('premium', 'gold') then
    return new;
  end if;

  select fc.id
    into v_forecast_card_id
  from public.forecast_cards fc
  where fc.type = v_plan_name
    and fc.result_status = 'pending'
    and fc.start_time > now()
  order by fc.start_time asc, fc.id desc
  limit 1;

  if v_forecast_card_id is not null then
    perform public.assign_forecast_to_user(
      new.user_id,
      v_forecast_card_id,
      new.plan_id
    );
  end if;

  return new;
end;
$$;

create or replace function public.distribute_forecast(
  p_forecast_card_id bigint
)
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_forecast_type text;
  v_plan_id bigint;
  v_user record;
  v_assignment_id bigint;
  v_assigned_count integer := 0;
begin
  select fc.type
    into v_forecast_type
  from public.forecast_cards fc
  where fc.id = p_forecast_card_id;

  if not found then
    raise exception 'Forecast card with id % not found', p_forecast_card_id;
  end if;

  if v_forecast_type not in ('premium', 'gold') then
    return 0;
  end if;

  select sp.id
    into v_plan_id
  from public.subscription_plans sp
  where lower(trim(sp.name)) = lower(trim(v_forecast_type))
  limit 1;

  if v_plan_id is null then
    raise exception 'Subscription plan for forecast type "%" not found', v_forecast_type;
  end if;

  for v_user in
    select distinct available_users.user_id
    from (
      select c.user_id
      from public.user_forecast_credits c
      where c.plan_id = v_plan_id
        and c.quantity_used < c.quantity_granted

      union

      select b.user_id
      from public.user_forecast_bonuses b
      join public.user_forecast_credits source_credit
        on source_credit.id = b.source_credit_id
      where source_credit.plan_id = v_plan_id
        and b.quantity_used < b.quantity_granted
    ) available_users
  loop
    v_assignment_id := public.assign_forecast_to_user(
      v_user.user_id,
      p_forecast_card_id,
      v_plan_id
    );

    if v_assignment_id is not null then
      v_assigned_count := v_assigned_count + 1;
    end if;
  end loop;

  return v_assigned_count;
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

  return new;
end;
$$;

create or replace function public.handle_forecast_result()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  /*
   * Обрабатываем только первый окончательный результат:
   * pending -> won
   * pending -> lost
   */
  if old.result_status <> 'pending' then
    return new;
  end if;

  if new.result_status not in ('won', 'lost') then
    return new;
  end if;

  /*
   * Для ordinary и express-прогнозов кредитная механика не используется.
   */
  if new.type not in ('premium', 'gold') then
    return new;
  end if;

  /*
   * При выигрыше бонус не начисляется.
   * Бонусная цепочка фактически завершается автоматически.
   */
  if new.result_status = 'won' then
    return new;
  end if;

  /*
   * При проигрыше создаём по одному бонусу для каждого assignment,
   * который был оплачен кредитом с bonus_until_win = true.
   *
   * Если прогноз был получен за уже выданный бонус, новый бонус
   * продолжает ту же цепочку. Для этого source_credit_id берём
   * либо напрямую из assignment.credit_id, либо через bonus_id.
   */
  insert into public.user_forecast_bonuses (
    user_id,
    source_credit_id,
    source_assignment_id,
    reason,
    quantity_granted,
    quantity_used
  )
  select
    a.user_id,
    coalesce(
      a.credit_id,
      source_bonus.source_credit_id
    ),
    a.id,
    'forecast_lost',
    1,
    0
  from public.user_forecast_assignments a
  left join public.user_forecast_bonuses source_bonus
    on source_bonus.id = a.bonus_id
  join public.user_forecast_credits source_credit
    on source_credit.id = coalesce(
      a.credit_id,
      source_bonus.source_credit_id
    )
  where a.forecast_card_id = new.id
    and a.bonus_granted = false
    and source_credit.bonus_until_win = true
  on conflict (source_assignment_id)
  do nothing;

  /*
   * Помечаем только те assignments, для которых запись бонуса реально существует.
   */
  update public.user_forecast_assignments a
  set bonus_granted = true
  where a.forecast_card_id = new.id
    and exists (
      select 1
      from public.user_forecast_bonuses b
      where b.source_assignment_id = a.id
    );

  return new;
end;
$$;

drop trigger if exists forecast_cards_after_insert
on public.forecast_cards;

create trigger forecast_cards_after_insert
after insert on public.forecast_cards
for each row
execute function public.on_forecast_created();

drop trigger if exists forecast_cards_after_result_update
on public.forecast_cards;

create trigger forecast_cards_after_result_update
after update of result_status
on public.forecast_cards
for each row
when (
  old.result_status is distinct from new.result_status
)
execute function public.handle_forecast_result();

drop trigger if exists user_forecast_credits_after_insert_assign_latest
on public.user_forecast_credits;

create trigger user_forecast_credits_after_insert_assign_latest
after insert on public.user_forecast_credits
for each row
execute function public.assign_latest_forecast_to_credit();

revoke execute on function public.assign_forecast_to_user(uuid, bigint, bigint)
from public, anon, authenticated;

revoke execute on function public.create_forecast_notification(bigint)
from public, anon, authenticated;

revoke execute on function public.assign_latest_forecast_to_credit()
from public, anon, authenticated;

revoke execute on function public.distribute_forecast(bigint)
from public, anon, authenticated;

revoke execute on function public.on_forecast_created()
from public, anon, authenticated;

revoke execute on function public.handle_forecast_result()
from public, anon, authenticated;