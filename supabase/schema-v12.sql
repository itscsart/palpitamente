-- ============================================================
-- Stickers da equipe, subidos pelo painel
-- Rode no SQL Editor DEPOIS do schema-v11.sql.
-- ============================================================

create table if not exists public.stickers_equipe (
  id          uuid primary key default gen_random_uuid(),
  pacote      text not null default 'Palpitamente',
  nome        text,
  imagem      text not null,              -- data:image/... em base64
  liberado_em integer not null default 0, -- páginas escritas para desbloquear
  ordem       integer default 0,
  created_at  timestamptz default now()
);
create index if not exists idx_stickers_equipe on public.stickers_equipe (pacote, ordem);

alter table public.stickers_equipe enable row level security;

-- qualquer usuária logada vê; só administradora sobe ou apaga
drop policy if exists "todas veem os stickers da equipe" on public.stickers_equipe;
create policy "todas veem os stickers da equipe"
  on public.stickers_equipe for select using (true);

drop policy if exists "so admin mexe nos stickers da equipe" on public.stickers_equipe;
create policy "so admin mexe nos stickers da equipe"
  on public.stickers_equipe for all
  using (public.eh_admin()) with check (public.eh_admin());

-- Limite de 120 stickers da equipe, para o banco não inchar.
-- Fica no banco e não no navegador, como as outras regras.
create or replace function public.limitar_stickers_equipe()
returns trigger as $$
declare quantos integer;
begin
  select count(*) into quantos from public.stickers_equipe;
  if quantos >= 120 then
    raise exception 'Limite de 120 stickers da equipe. Apague algum antes de subir outro.';
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_limitar_stickers_equipe on public.stickers_equipe;
create trigger trg_limitar_stickers_equipe
  before insert on public.stickers_equipe
  for each row execute procedure public.limitar_stickers_equipe();

select count(*) as stickers_da_equipe from public.stickers_equipe;
