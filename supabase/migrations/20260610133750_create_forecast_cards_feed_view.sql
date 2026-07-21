create or replace view public.forecast_cards_feed_view
with (security_invoker = true)
as
select
  fc.id as card_id,
  fc.type,
  fc.total_odds,
  fc.start_time,
  fc.result_status,
  fc.created_at,
  fc.updated_at,

  '|all|' ||
  coalesce((
    select string_agg(s.sport, '|' order by s.sport)
    from (
      select distinct fe.sport
      from public.forecast_events fe
      where fe.forecast_card_id = fc.id
    ) s
  ), '') ||
  '|' as sports_filter

from public.forecast_cards fc;