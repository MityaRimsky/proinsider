alter table public.forecast_cards
add column if not exists analytics_title text,
add column if not exists analytics_text text,
add column if not exists analytics_summary text;
