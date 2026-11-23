-- Megrendelések tábla a landing oldal kérdőívéhez.
-- Futtassa a Supabase SQL Editorban, majd másolja a projekt URL-jét és az anon kulcsot
-- az index.html CONFIG.supabase részébe.

create table if not exists public.megrendelesek (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  csomag      text not null,
  vallalkozas text,
  nev         text,
  email       text,
  telefon     text,
  adatok      jsonb not null,
  statusz     text not null default 'uj'
);

alter table public.megrendelesek enable row level security;

-- A nyilvános (anon) kulccsal csak beküldeni lehet, olvasni, módosítani, törölni nem.
create policy "anon_insert_only"
  on public.megrendelesek
  for insert
  to anon
  with check (
    char_length(coalesce(email, '')) between 5 and 200
    and octet_length(adatok::text) < 20000
  );
