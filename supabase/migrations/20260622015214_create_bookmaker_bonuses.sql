create table if not exists public.bookmaker_bonuses (
    id bigint generated always as identity primary key,

    logo_url text not null,
    title text not null,
    url text not null,

    sort_order integer not null default 0,
    is_active boolean not null default true,

    created_at timestamptz not null default now()
);

create index if not exists idx_bookmaker_bonuses_sort
on public.bookmaker_bonuses(sort_order);

alter table public.bookmaker_bonuses enable row level security;

drop policy if exists "Anyone can view active bookmaker bonuses"
on public.bookmaker_bonuses;

create policy "Anyone can view active bookmaker bonuses"
on public.bookmaker_bonuses
for select
using (is_active = true);