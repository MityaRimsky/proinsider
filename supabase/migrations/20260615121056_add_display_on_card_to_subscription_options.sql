alter table public.subscription_options
add column if not exists display_on_card boolean not null default false;
