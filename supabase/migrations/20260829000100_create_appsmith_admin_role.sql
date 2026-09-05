do $$
begin
  if not exists (
    select 1
    from pg_roles
    where rolname = 'appsmith_admin'
  ) then
    create role appsmith_admin login;
  end if;
end
$$;

alter role appsmith_admin
  login
  nosuperuser
  nocreatedb
  nocreaterole
  nobypassrls;

grant connect on database postgres
to appsmith_admin;

grant usage on schema public
to appsmith_admin;

grant select, insert, update, delete
on all tables in schema public
to appsmith_admin;

grant usage, select
on all sequences in schema public
to appsmith_admin;
