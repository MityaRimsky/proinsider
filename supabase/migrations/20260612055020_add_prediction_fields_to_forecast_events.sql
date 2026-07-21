alter table public.forecast_events
add column if not exists prediction_text text,
add column if not exists home_score text,
add column if not exists away_score text,
add column if not exists winner_team_id bigint references public.teams(id);
