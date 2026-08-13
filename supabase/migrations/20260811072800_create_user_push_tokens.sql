begin;

create table if not exists public.user_push_tokens (
  id uuid primary key default gen_random_uuid(),

  user_id uuid not null
    references auth.users(id)
    on delete cascade,

  fcm_token text not null,

  platform text not null
    check (platform in ('android', 'ios')),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint user_push_tokens_fcm_token_key unique (fcm_token)
);

create index if not exists user_push_tokens_user_id_idx
  on public.user_push_tokens(user_id);

create index if not exists user_push_tokens_updated_at_idx
  on public.user_push_tokens(updated_at desc);

alter table public.user_push_tokens enable row level security;

drop policy if exists "Users can read own push tokens"
on public.user_push_tokens;

create policy "Users can read own push tokens"
on public.user_push_tokens
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can insert own push tokens"
on public.user_push_tokens;

create policy "Users can insert own push tokens"
on public.user_push_tokens
for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update own push tokens"
on public.user_push_tokens;

create policy "Users can update own push tokens"
on public.user_push_tokens
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete own push tokens"
on public.user_push_tokens;

create policy "Users can delete own push tokens"
on public.user_push_tokens
for delete
to authenticated
using ((select auth.uid()) = user_id);

create or replace function public.set_user_push_tokens_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

revoke all
on function public.set_user_push_tokens_updated_at()
from public, anon, authenticated;

drop trigger if exists set_user_push_tokens_updated_at
on public.user_push_tokens;

create trigger set_user_push_tokens_updated_at
before update on public.user_push_tokens
for each row
execute function public.set_user_push_tokens_updated_at();

commit;