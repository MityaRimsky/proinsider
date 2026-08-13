create or replace view public.my_subscription_status
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
  p.id as plan_id,
  p.name as plan_name,

  case
    when lower(trim(p.name)) in ('premium', 'gold')
      then coalesce(b.total_remaining, 0)
    else null
  end as remaining_forecasts,

  case
    when lower(trim(p.name)) = 'live'
      then ls.expires_at
    else null
  end as expires_at,

  case
    when lower(trim(p.name)) in ('premium', 'gold')
      then coalesce(b.total_remaining, 0) > 0
    when lower(trim(p.name)) = 'live'
      then ls.expires_at is not null
    else false
  end as has_access

from public.subscription_plans p

left join public.user_forecast_balances b
  on b.plan_id = p.id
 and b.user_id = auth.uid()

left join live_status ls
  on ls.plan_id = p.id
 and ls.user_id = auth.uid()

where lower(trim(p.name)) in ('premium', 'gold', 'live');

grant select on public.my_subscription_status
to authenticated;