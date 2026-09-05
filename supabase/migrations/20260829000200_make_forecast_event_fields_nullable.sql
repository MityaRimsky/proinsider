alter table public.forecast_events
  alter column event_time drop not null,
  alter column bet_market drop not null;
