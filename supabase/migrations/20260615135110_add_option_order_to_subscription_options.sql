alter table public.subscription_options
add column if not exists option_order int not null default 1;
