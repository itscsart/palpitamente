-- ============================================================
-- PAUSA PARA MIM — stickers enviados pela usuária
-- Rode no SQL Editor DEPOIS do schema-v5.sql.
-- ============================================================

create table if not exists public.stickers_usuaria (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users(id) on delete cascade,
  nome       text,
  imagem     text not null,                       -- data:image/... em base64
  created_at timestamptz default now()
);
create index if not exists idx_stickers_usuaria on public.stickers_usuaria (user_id, created_at desc);

alter table public.stickers_usuaria enable row level security;

drop policy if exists "cada uma mexe nos proprios stickers" on public.stickers_usuaria;
create policy "cada uma mexe nos proprios stickers"
  on public.stickers_usuaria for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Limite de 60 stickers por usuária, para o banco não inchar.
-- Feito no banco e não no navegador: no JS, bastava burlar a checagem.
create or replace function public.limitar_stickers()
returns trigger as $$
declare
  quantos integer;
begin
  select count(*) into quantos from public.stickers_usuaria where user_id = new.user_id;
  if quantos >= 60 then
    raise exception 'Você já tem 60 stickers. Apague algum antes de subir outro.';
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_limitar_stickers on public.stickers_usuaria;
create trigger trg_limitar_stickers
  before insert on public.stickers_usuaria
  for each row execute procedure public.limitar_stickers();
