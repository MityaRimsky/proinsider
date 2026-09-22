do $$
begin
  if to_regclass('public.payments') is null then
    raise exception 'Table public.payments does not exist';
  end if;

  if not exists (
    select 1
    from pg_roles
    where rolname = 'appsmith_admin'
  ) then
    raise exception 'Role appsmith_admin does not exist';
  end if;
end
$$;

revoke all privileges
on table public.payments
from appsmith_admin;

grant select
on table public.payments
to appsmith_admin;

drop policy if exists "Appsmith admin can view payments"
on public.payments;

create policy "Appsmith admin can view payments"
on public.payments
for select
to appsmith_admin
using (true);
