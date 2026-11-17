-- Tuningrechner: Cloud-Speicher für Supabase (im SQL Editor komplett einfügen und ausführen)
-- Jeder Arbeitsbereich wird über einen langen, zufälligen, geheimen Code angesprochen.
-- Auf die Tabelle selbst hat niemand direkten Zugriff, nur über die beiden Funktionen unten.

create table if not exists public.workspaces (
  code text primary key check (length(code) between 16 and 64),
  data jsonb not null,
  rev integer not null default 0,
  updated_at timestamptz not null default now()
);
alter table public.workspaces enable row level security;   -- keine Policies = kein direkter Zugriff
revoke all on public.workspaces from anon, authenticated;

-- Stand lesen: liefert {"data": ..., "rev": n} oder null, wenn der Code neu ist
create or replace function public.ws_get(p_code text) returns jsonb
language sql security definer stable set search_path = public as $$
  select jsonb_build_object('data', data, 'rev', rev) from public.workspaces where code = p_code
$$;

-- Stand speichern. Nur wenn p_rev der aktuellen Version entspricht, sonst Fehler "conflict".
-- So überschreibt kein Gerät unbemerkt die Änderungen eines anderen.
create or replace function public.ws_set(p_code text, p_data jsonb, p_rev integer) returns integer
language plpgsql security definer set search_path = public as $$
declare cur integer;
begin
  if p_code is null or length(p_code) not between 16 and 64 or p_code !~ '^[A-Za-z0-9_-]+$' then
    raise exception 'ungueltiger Code';
  end if;
  if p_data is null or jsonb_typeof(p_data) <> 'object' or octet_length(p_data::text) > 2000000 then
    raise exception 'ungueltige Daten';
  end if;
  select rev into cur from public.workspaces where code = p_code for update;
  if not found then
    insert into public.workspaces (code, data, rev) values (p_code, p_data, 1) on conflict (code) do nothing;
    if not found then raise exception 'conflict'; end if;
    return 1;
  end if;
  if cur <> p_rev then raise exception 'conflict'; end if;
  update public.workspaces set data = p_data, rev = cur + 1, updated_at = now() where code = p_code;
  return cur + 1;
end $$;

revoke all on function public.ws_get(text), public.ws_set(text, jsonb, integer) from public;
grant execute on function public.ws_get(text), public.ws_set(text, jsonb, integer) to anon, authenticated;
