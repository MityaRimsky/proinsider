create or replace view public.my_notifications
with (security_invoker = true)
as
select n.*
from public.notifications n
where
(
  n.forecast_card_id is not null
  and exists (
    select 1
    from public.user_forecast_assignments a
    where a.forecast_card_id = n.forecast_card_id
      and a.user_id = auth.uid()
  )
)
or
(
  n.plan_type = 'live'
  and exists (
    select 1
    from public.user_live_subscriptions s
    join public.subscription_plans p
      on p.id = s.plan_id
    where s.user_id = auth.uid()
      and s.status = 'active'
      and s.expires_at > now()
      and p.name = 'live'
  )
);

grant select on public.my_notifications to authenticated;
