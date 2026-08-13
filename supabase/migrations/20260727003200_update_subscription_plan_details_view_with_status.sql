drop view if exists public.my_subscription_status;

create or replace view public.subscription_plan_details_view
with (security_invoker = true)
as
with live_status as (
  select
    s.user_id,
    s.plan_id,
    max(s.expires_at) as expires_at
  from public.user_live_subscriptions s
  where s.user_id = auth.uid()
    and s.status = 'active'
    and s.expires_at > now()
  group by s.user_id, s.plan_id
)
select
  sp.id as plan_id,
  sp.name,
  sp.subtitle,

  sp.feature_1,
  sp.feature_2,
  sp.feature_3,
  sp.feature_4,
  sp.feature_5,

  o1.id as option1_id,
  o1.name as option1_name,
  o1.price as option1_price,

  o2.id as option2_id,
  o2.name as option2_name,
  o2.price as option2_price,

  case
    when lower(trim(sp.name)) in ('premium', 'gold')
      then coalesce(b.total_remaining, 0)
    else null
  end as remaining_forecasts,

  case
    when lower(trim(sp.name)) = 'live'
      then ls.expires_at
    else null
  end as expires_at,

  case
    when lower(trim(sp.name)) in ('premium', 'gold')
      then coalesce(b.total_remaining, 0) > 0
    when lower(trim(sp.name)) = 'live'
      then ls.expires_at is not null
    else false
  end as has_access

from public.subscription_plans sp

left join public.subscription_options o1
  on o1.plan_id = sp.id
 and o1.option_order = 1

left join public.subscription_options o2
  on o2.plan_id = sp.id
 and o2.option_order = 2

left join public.user_forecast_balances b
  on b.plan_id = sp.id
 and b.user_id = auth.uid()

left join live_status ls
  on ls.plan_id = sp.id
 and ls.user_id = auth.uid();

grant select on public.subscription_plan_details_view
to anon, authenticated;