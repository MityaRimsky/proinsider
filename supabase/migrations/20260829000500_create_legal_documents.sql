create table if not exists public.legal_documents (
  id uuid primary key default gen_random_uuid(),

  document_key text not null unique,
  title text not null,
  content text not null,

  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.legal_documents
enable row level security;

drop policy if exists "Legal documents are publicly readable"
on public.legal_documents;

create policy "Legal documents are publicly readable"
on public.legal_documents
for select
using (is_active = true);

grant select on public.legal_documents
to anon, authenticated;

drop trigger if exists legal_documents_set_updated_at
on public.legal_documents;

create trigger legal_documents_set_updated_at
before update on public.legal_documents
for each row
execute function public.set_updated_at();
