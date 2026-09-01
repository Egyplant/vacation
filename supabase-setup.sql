-- Выполните этот файл один раз в Supabase: SQL Editor -> New query -> Run.
-- Перед запуском замените два email ниже на ваши настоящие адреса.

create table if not exists public.trip_members (
  email text primary key,
  added_at timestamptz not null default now()
);

create table if not exists public.trip_state (
  trip_id text primary key,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id) on delete set null
);

alter table public.trip_members enable row level security;
alter table public.trip_state enable row level security;

drop policy if exists "Members can see own membership" on public.trip_members;
create policy "Members can see own membership"
on public.trip_members
for select
to authenticated
using (lower(email) = lower(auth.jwt() ->> 'email'));

drop policy if exists "Members can read shared trip" on public.trip_state;
create policy "Members can read shared trip"
on public.trip_state
for select
to authenticated
using (
  exists (
    select 1 from public.trip_members
    where lower(email) = lower(auth.jwt() ->> 'email')
  )
);

drop policy if exists "Members can insert shared trip" on public.trip_state;
create policy "Members can insert shared trip"
on public.trip_state
for insert
to authenticated
with check (
  exists (
    select 1 from public.trip_members
    where lower(email) = lower(auth.jwt() ->> 'email')
  )
);

drop policy if exists "Members can update shared trip" on public.trip_state;
create policy "Members can update shared trip"
on public.trip_state
for update
to authenticated
using (
  exists (
    select 1 from public.trip_members
    where lower(email) = lower(auth.jwt() ->> 'email')
  )
)
with check (
  exists (
    select 1 from public.trip_members
    where lower(email) = lower(auth.jwt() ->> 'email')
  )
);

grant select on public.trip_members to authenticated;
grant select, insert, update on public.trip_state to authenticated;

insert into public.trip_members (email)
values
  ('YOUR_EMAIL@example.com'),
  ('GIRLFRIEND_EMAIL@example.com')
on conflict (email) do nothing;

insert into public.trip_state (trip_id)
values ('europe-september-2026')
on conflict (trip_id) do nothing;

alter table public.trip_state replica identity full;

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'trip_state'
  ) then
    alter publication supabase_realtime add table public.trip_state;
  end if;
end $$;

