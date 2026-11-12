-- CHTC Collection Manager: run once in Supabase > SQL Editor
create table if not exists public.specimens (
  id text primary key,
  upd bigint not null default 0,
  deleted boolean not null default false,
  "voucher" text not null default '',
  "order" text not null default '',
  "family" text not null default '',
  "genus" text not null default '',
  "species" text not null default '',
  "detby" text not null default '',
  "country" text not null default '',
  "state" text not null default '',
  "municipality" text not null default '',
  "locality" text not null default '',
  "lat" text not null default '',
  "lon" text not null default '',
  "coordsource" text not null default '',
  "collectors" text not null default '',
  "fieldnumber" text not null default '',
  "date" text not null default '',
  "sex" text not null default '',
  "fieldnotes" text not null default '',
  "remarks" text not null default '',
  "prep" text not null default '',
  "pres" text not null default '',
  "mass" text not null default '',
  "svl" text not null default '',
  "tail" text not null default '',
  "photo" text not null default '',
  "call" text not null default '',
  "tissuesample" text not null default '',
  "tissuepres" text not null default '',
  "tissuebox" text not null default '',
  "tissueboxloc" text not null default '',
  "dnabox" text not null default '',
  "dnaboxloc" text not null default '',
  "depdate" text not null default '',
  "depby" text not null default '',
  "collloc" text not null default '',
  "status" text not null default '',
  "loandate" text not null default '',
  "loanborrower" text not null default '',
  "loaninst" text not null default '',
  "loandept" text not null default '',
  "loanpos" text not null default '',
  "loanemail" text not null default '',
  "loanphone" text not null default '',
  "loanperiod" text not null default '',
  "loanreturned" text not null default ''
);
alter table public.specimens add column if not exists "voucher" text not null default '';
alter table public.specimens add column if not exists "order" text not null default '';
alter table public.specimens add column if not exists "family" text not null default '';
alter table public.specimens add column if not exists "genus" text not null default '';
alter table public.specimens add column if not exists "species" text not null default '';
alter table public.specimens add column if not exists "detby" text not null default '';
alter table public.specimens add column if not exists "country" text not null default '';
alter table public.specimens add column if not exists "state" text not null default '';
alter table public.specimens add column if not exists "municipality" text not null default '';
alter table public.specimens add column if not exists "locality" text not null default '';
alter table public.specimens add column if not exists "lat" text not null default '';
alter table public.specimens add column if not exists "lon" text not null default '';
alter table public.specimens add column if not exists "coordsource" text not null default '';
alter table public.specimens add column if not exists "collectors" text not null default '';
alter table public.specimens add column if not exists "fieldnumber" text not null default '';
alter table public.specimens add column if not exists "date" text not null default '';
alter table public.specimens add column if not exists "sex" text not null default '';
alter table public.specimens add column if not exists "fieldnotes" text not null default '';
alter table public.specimens add column if not exists "remarks" text not null default '';
alter table public.specimens add column if not exists "prep" text not null default '';
alter table public.specimens add column if not exists "pres" text not null default '';
alter table public.specimens add column if not exists "mass" text not null default '';
alter table public.specimens add column if not exists "svl" text not null default '';
alter table public.specimens add column if not exists "tail" text not null default '';
alter table public.specimens add column if not exists "photo" text not null default '';
alter table public.specimens add column if not exists "call" text not null default '';
alter table public.specimens add column if not exists "tissuesample" text not null default '';
alter table public.specimens add column if not exists "tissuepres" text not null default '';
alter table public.specimens add column if not exists "tissuebox" text not null default '';
alter table public.specimens add column if not exists "tissueboxloc" text not null default '';
alter table public.specimens add column if not exists "dnabox" text not null default '';
alter table public.specimens add column if not exists "dnaboxloc" text not null default '';
alter table public.specimens add column if not exists "depdate" text not null default '';
alter table public.specimens add column if not exists "depby" text not null default '';
alter table public.specimens add column if not exists "collloc" text not null default '';
alter table public.specimens add column if not exists "status" text not null default '';
alter table public.specimens add column if not exists "loandate" text not null default '';
alter table public.specimens add column if not exists "loanborrower" text not null default '';
alter table public.specimens add column if not exists "loaninst" text not null default '';
alter table public.specimens add column if not exists "loandept" text not null default '';
alter table public.specimens add column if not exists "loanpos" text not null default '';
alter table public.specimens add column if not exists "loanemail" text not null default '';
alter table public.specimens add column if not exists "loanphone" text not null default '';
alter table public.specimens add column if not exists "loanperiod" text not null default '';
alter table public.specimens add column if not exists "loanreturned" text not null default '';
create index if not exists specimens_upd_idx on public.specimens (upd);
create unique index if not exists specimens_voucher_uq on public.specimens (lower(voucher)) where deleted = false and voucher <> '';
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text, name text,
  role text not null default 'pending' check (role in ('pending','viewer','editor','admin'))
);
create or replace function public.my_role() returns text language sql stable security definer set search_path = public as $$ select role from public.profiles where id = auth.uid() $$;
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, name, role) values (new.id, new.email, coalesce(new.raw_user_meta_data->>'name', new.email),
    case when not exists (select 1 from public.profiles) then 'admin' else 'pending' end);
  return new;
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();
insert into public.profiles (id, email, name, role) select id, email, email, 'pending' from auth.users on conflict do nothing;
update public.profiles set role = 'admin' where id = (select id from auth.users order by created_at limit 1) and not exists (select 1 from public.profiles where role = 'admin');
alter table public.specimens enable row level security;
alter table public.profiles enable row level security;
revoke all on public.specimens, public.profiles from anon;
grant select, insert, update, delete on public.specimens, public.profiles to authenticated;
drop policy if exists sp_select on public.specimens;
drop policy if exists sp_insert on public.specimens;
drop policy if exists sp_update on public.specimens;
drop policy if exists sp_delete on public.specimens;
create policy sp_select on public.specimens for select to authenticated using (public.my_role() in ('viewer','editor','admin'));
create policy sp_insert on public.specimens for insert to authenticated with check (public.my_role() = 'admin' or (public.my_role() = 'editor' and not deleted));
create policy sp_update on public.specimens for update to authenticated using (public.my_role() = 'admin' or (public.my_role() = 'editor' and not deleted)) with check (public.my_role() = 'admin' or (public.my_role() = 'editor' and not deleted));
create policy sp_delete on public.specimens for delete to authenticated using (public.my_role() = 'admin');
drop policy if exists pr_select on public.profiles;
drop policy if exists pr_update on public.profiles;
create policy pr_select on public.profiles for select to authenticated using (id = auth.uid() or public.my_role() = 'admin');
create policy pr_update on public.profiles for update to authenticated using (public.my_role() = 'admin') with check (public.my_role() = 'admin');
