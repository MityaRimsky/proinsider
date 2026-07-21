drop view if exists public.forecast_details_view;

create view public.forecast_details_view
with (security_invoker = true)
as
select
  fe.id as event_id,
  fe.forecast_card_id,
  fe.sport,
  fe.league,
  fe.bet_market,
  fe.odds,
  fe.prediction_text,
  fe.home_score,
  fe.away_score,
  fe.winner_team_id,
  fe.sort_order,

  fe.home_team_id,
  home_team.name as home_team_name,
  home_team.logo_url as home_team_logo_url,

  fe.away_team_id,
  away_team.name as away_team_name,
  away_team.logo_url as away_team_logo_url

from public.forecast_events fe

left join public.teams home_team
  on home_team.id = fe.home_team_id

left join public.teams away_team
  on away_team.id = fe.away_team_id;
