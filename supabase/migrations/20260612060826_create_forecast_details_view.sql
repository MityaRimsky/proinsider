create or replace view public.forecast_details_view
with (security_invoker = true)
as
select
  fc.id as card_id,
  fc.type,
  fc.total_odds,
  fc.start_time,
  fc.result_status,
  fc.analytics_title,
  fc.analytics_text,
  fc.analytics_summary,

  fe.id as event_id,
  fe.sport,
  fe.league,
  fe.event_time,
  fe.bet_market,
  fe.odds,
  fe.prediction_text,
  fe.home_score,
  fe.away_score,
  fe.winner_team_id,
  fe.sort_order,

  home_team.name as home_team_name,
  home_team.logo_url as home_team_logo_url,

  away_team.name as away_team_name,
  away_team.logo_url as away_team_logo_url

from public.forecast_cards fc
left join public.forecast_events fe
  on fe.forecast_card_id = fc.id

left join public.teams home_team
  on home_team.id = fe.home_team_id

left join public.teams away_team
  on away_team.id = fe.away_team_id;
