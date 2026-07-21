create or replace view public.forecast_cards_details_view
with (security_invoker = true)
as
select
  fc.*,
  count(fe.id)::int as events_count,
  case
    when count(fe.id) = 1 then 'Ординар'
    when count(fe.id) > 1 then 'Экспресс'
    else null
  end as bet_format
from public.forecast_cards fc
left join public.forecast_events fe
  on fe.forecast_card_id = fc.id
group by fc.id;