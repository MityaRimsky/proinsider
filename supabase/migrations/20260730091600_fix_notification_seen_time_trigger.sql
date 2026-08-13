begin;

alter table public.user_notification_state
  drop column if exists updated_at;

create or replace function public.handle_new_user_notification_state()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.user_notification_state (
    user_id,
    last_seen_at
  )
  values (
    new.id,
    now()
  )
  on conflict (user_id) do nothing;

  return new;
end;
$$;

revoke all
on function public.handle_new_user_notification_state()
from public, anon, authenticated;

create or replace function public.set_notification_state_seen_time()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.last_seen_at := now();
  return new;
end;
$$;

revoke all
on function public.set_notification_state_seen_time()
from public, anon, authenticated;

drop trigger if exists set_notification_state_seen_time
on public.user_notification_state;

create trigger set_notification_state_seen_time
before update on public.user_notification_state
for each row
execute function public.set_notification_state_seen_time();

commit;