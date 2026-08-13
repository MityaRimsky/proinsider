begin;

create table if not exists public.user_notification_state (
  user_id uuid primary key
    references auth.users(id)
    on delete cascade,

  last_seen_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.user_notification_state
enable row level security;

drop policy if exists "Users can view own notification state"
on public.user_notification_state;

create policy "Users can view own notification state"
on public.user_notification_state
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can update own notification state"
on public.user_notification_state;

create policy "Users can update own notification state"
on public.user_notification_state
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create or replace function public.handle_new_user_notification_state()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.user_notification_state (
    user_id,
    last_seen_at,
    updated_at
  )
  values (
    new.id,
    now(),
    now()
  )
  on conflict (user_id) do nothing;

  return new;
end;
$$;

revoke all
on function public.handle_new_user_notification_state()
from public, anon, authenticated;

drop trigger if exists on_auth_user_created_notification_state
on auth.users;

create trigger on_auth_user_created_notification_state
after insert on auth.users
for each row
execute function public.handle_new_user_notification_state();

insert into public.user_notification_state (
  user_id,
  last_seen_at,
  updated_at
)
select
  u.id,
  now(),
  now()
from auth.users u
on conflict (user_id) do nothing;

create or replace view public.my_unread_notifications_count
with (security_invoker = true)
as
select
  count(*)::integer as unread_count
from public.my_notifications n
join public.user_notification_state s
  on s.user_id = (select auth.uid())
where n.created_at > s.last_seen_at;

grant select
on public.my_unread_notifications_count
to authenticated;

commit;