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
      select distinct fe2.sport
      from public.forecast_events fe2
      where fe2.forecast_card_id = fc.id
    ) s
  ), '') ||
  '|' as sports_filter,

  fe.id as event_id,
  fe.sport as event_sport,
  fe.league as event_league,
  fe.event_time,
  fe.bet_market,
  fe.odds as event_odds,

  home_team.id as home_team_id,
  home_team.name as home_team_name,
  home_team.logo_url as home_team_logo_url,

  away_team.id as away_team_id,
  away_team.name as away_team_name,
  away_team.logo_url as away_team_logo_url,

  case
    when fc.type in ('ordinary', 'express') then true
    when fc.result_status in ('won', 'lost') then true
    when exists (
      select 1
      from public.user_forecast_assignments ufa
      where ufa.forecast_card_id = fc.id
        and ufa.user_id = auth.uid()
    ) then true
    else false
  end as has_access,

  case
    when fc.type in ('premium', 'gold')
     and fc.result_status = 'pending'
     and fc.start_time > now()
     and not exists (
       select 1
       from public.user_forecast_assignments ufa
       where ufa.forecast_card_id = fc.id
         and ufa.user_id = auth.uid()
     )
    then true
    else false
  end as can_purchase

from public.forecast_cards fc

left join lateral (
  select *
  from public.forecast_events fe
  where fe.forecast_card_id = fc.id
    and fc.type = 'ordinary'
  order by fe.sort_order asc, fe.id asc
  limit 1
) fe on true

left join public.teams home_team
  on home_team.id = fe.home_team_id

left join public.teams away_team
  on away_team.id = fe.away_team_id;

grant select on public.forecast_cards_feed_view
to anon, authenticated;