create or replace view public.ordinary_events_view
with (security_invoker = true)
as
select
  fe.id as event_id,
  fe.forecast_card_id,
  fe.sport,
  fe.league,
  fe.event_time,
  fe.bet_market,
  fe.odds,
  fe.result_status,
  fe.sort_order,

  home_team.id as home_team_id,
  home_team.name as home_team_name,
  home_team.logo_url as home_team_logo_url,

  away_team.id as away_team_id,
  away_team.name as away_team_name,
  away_team.logo_url as away_team_logo_url

from public.forecast_events fe

left join public.teams home_team
  on home_team.id = fe.home_team_id

left join public.teams away_team
  on away_team.id = fe.away_team_id;