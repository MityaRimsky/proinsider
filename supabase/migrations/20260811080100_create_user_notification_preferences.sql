begin;

create table if not exists public.user_notification_preferences (
  user_id uuid primary key
    references auth.users(id)
    on delete cascade,

  push_enabled boolean not null default true,
  email_enabled boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists user_notification_preferences_updated_at_idx
  on public.user_notification_preferences(updated_at desc);

alter table public.user_notification_preferences enable row level security;

drop policy if exists "Users can read own notification preferences"
on public.user_notification_preferences;

create policy "Users can read own notification preferences"
on public.user_notification_preferences
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can update own notification preferences"
on public.user_notification_preferences;

create policy "Users can update own notification preferences"
on public.user_notification_preferences
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create or replace function public.set_user_notification_preferences_updated_at()
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
on function public.set_user_notification_preferences_updated_at()
from public, anon, authenticated;

drop trigger if exists set_user_notification_preferences_updated_at
on public.user_notification_preferences;

create trigger set_user_notification_preferences_updated_at
before update on public.user_notification_preferences
for each row
execute function public.set_user_notification_preferences_updated_at();

create or replace function public.create_notification_preferences_on_confirmation()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.user_notification_preferences (
    user_id,
    push_enabled,
    email_enabled
  )
  values (
    new.id,
    true,
    true
  )
  on conflict (user_id) do nothing;

  return new;
end;
$$;

revoke all
on function public.create_notification_preferences_on_confirmation()
from public, anon, authenticated;

drop trigger if exists create_notification_preferences_on_confirmation
on auth.users;

create trigger create_notification_preferences_on_confirmation
after update of email_confirmed_at
on auth.users
for each row
when (
  old.email_confirmed_at is null
  and new.email_confirmed_at is not null
)
execute function public.create_notification_preferences_on_confirmation();

insert into public.user_notification_preferences (
  user_id,
  push_enabled,
  email_enabled
)
select
  id,
  true,
  true
from auth.users
where email_confirmed_at is not null
on conflict (user_id) do nothing;

commit;