-- ============================================================
-- PAUSA PARA MIM — ampliação do banco
-- Rode no SQL Editor do Supabase DEPOIS do schema.sql original.
-- Pode rodar mais de uma vez sem quebrar nada.
-- ============================================================

-- ------------------------------------------------------------
-- 1) Campos novos nas entradas do diário
-- ------------------------------------------------------------
alter table public.diary_entries
  add column if not exists titulo            text,
  add column if not exists numero_pagina     integer,
  add column if not exists data_pagina       date default current_date,
  add column if not exists conteudo_rico     jsonb default '{}'::jsonb,  -- texto, desenho, fotos, stickers
  add column if not exists comentarios_on    boolean default true,
  add column if not exists atualizado_em     timestamptz default now();

-- a coluna "content" original vira opcional: o conteúdo agora vive no jsonb
alter table public.diary_entries alter column content drop not null;

create index if not exists idx_entradas_usuaria   on public.diary_entries (user_id, data_pagina desc);
create index if not exists idx_entradas_publicas  on public.diary_entries (is_public, created_at desc) where is_public = true;

-- ------------------------------------------------------------
-- 2) Curtidas
-- ------------------------------------------------------------
create table if not exists public.entry_likes (
  id          uuid primary key default gen_random_uuid(),
  entry_id    uuid not null references public.diary_entries(id) on delete cascade,
  user_id     uuid not null references auth.users(id) on delete cascade,
  created_at  timestamptz default now(),
  unique (entry_id, user_id)          -- uma curtida por pessoa
);
create index if not exists idx_likes_entrada on public.entry_likes (entry_id);

-- ------------------------------------------------------------
-- 3) Comentários
-- ------------------------------------------------------------
create table if not exists public.entry_comments (
  id          uuid primary key default gen_random_uuid(),
  entry_id    uuid not null references public.diary_entries(id) on delete cascade,
  user_id     uuid not null references auth.users(id) on delete cascade,
  texto       text not null check (char_length(trim(texto)) between 1 and 1000),
  oculto      boolean default false,   -- a autora da página pode ocultar
  created_at  timestamptz default now()
);
create index if not exists idx_comentarios_entrada on public.entry_comments (entry_id, created_at);

-- ------------------------------------------------------------
-- 4) Denúncias (diretrizes da comunidade)
-- ------------------------------------------------------------
create table if not exists public.comment_reports (
  id          uuid primary key default gen_random_uuid(),
  comment_id  uuid not null references public.entry_comments(id) on delete cascade,
  user_id     uuid not null references auth.users(id) on delete cascade,
  motivo      text not null,
  created_at  timestamptz default now(),
  unique (comment_id, user_id)
);

-- ============================================================
-- SEGURANÇA
-- Sem isso, qualquer pessoa logada consegue apagar comentário
-- e curtida de outra. As políticas abaixo impedem isso.
-- ============================================================
alter table public.entry_likes     enable row level security;
alter table public.entry_comments  enable row level security;
alter table public.comment_reports enable row level security;

-- ---- curtidas ----
drop policy if exists "ler curtidas de paginas publicas" on public.entry_likes;
create policy "ler curtidas de paginas publicas"
  on public.entry_likes for select
  using (exists (select 1 from public.diary_entries e
                 where e.id = entry_id and (e.is_public or e.user_id = auth.uid())));

drop policy if exists "curtir so em nome proprio" on public.entry_likes;
create policy "curtir so em nome proprio"
  on public.entry_likes for insert
  with check (auth.uid() = user_id
              and exists (select 1 from public.diary_entries e
                          where e.id = entry_id and e.is_public));

drop policy if exists "descurtir so a propria" on public.entry_likes;
create policy "descurtir so a propria"
  on public.entry_likes for delete
  using (auth.uid() = user_id);

-- ---- comentários ----
drop policy if exists "ler comentarios visiveis" on public.entry_comments;
create policy "ler comentarios visiveis"
  on public.entry_comments for select
  using (
    exists (select 1 from public.diary_entries e
            where e.id = entry_id
              and (e.user_id = auth.uid()                 -- a autora vê tudo, inclusive ocultos
                   or (e.is_public and not oculto)))
  );

drop policy if exists "comentar so em nome proprio" on public.entry_comments;
create policy "comentar so em nome proprio"
  on public.entry_comments for insert
  with check (
    auth.uid() = user_id
    and exists (select 1 from public.diary_entries e
                where e.id = entry_id and e.is_public and e.comentarios_on)
  );

-- apagar: a autora do comentário OU a dona da página
drop policy if exists "apagar comentario proprio ou da propria pagina" on public.entry_comments;
create policy "apagar comentario proprio ou da propria pagina"
  on public.entry_comments for delete
  using (
    auth.uid() = user_id
    or exists (select 1 from public.diary_entries e
               where e.id = entry_id and e.user_id = auth.uid())
  );

-- ocultar: só a dona da página
drop policy if exists "ocultar comentario na propria pagina" on public.entry_comments;
create policy "ocultar comentario na propria pagina"
  on public.entry_comments for update
  using (exists (select 1 from public.diary_entries e
                 where e.id = entry_id and e.user_id = auth.uid()));

-- ---- denúncias ----
drop policy if exists "denunciar em nome proprio" on public.comment_reports;
create policy "denunciar em nome proprio"
  on public.comment_reports for insert with check (auth.uid() = user_id);

drop policy if exists "ver as proprias denuncias" on public.comment_reports;
create policy "ver as proprias denuncias"
  on public.comment_reports for select using (auth.uid() = user_id);

-- ------------------------------------------------------------
-- 5) Perfis: quem está no feed precisa ver o nome de quem escreveu
-- ------------------------------------------------------------
drop policy if exists "ler nome de quem publica" on public.profiles;
create policy "ler nome de quem publica"
  on public.profiles for select
  using (
    id = auth.uid()
    or exists (select 1 from public.diary_entries e
               where e.user_id = profiles.id and e.is_public)
  );

-- ------------------------------------------------------------
-- 6) Contador de páginas: mantido pelo banco, não pelo navegador
--    (se ficar só no JS, dá para burlar e liberar recompensa à toa)
-- ------------------------------------------------------------
create or replace function public.recontar_paginas()
returns trigger as $$
declare
  alvo uuid := coalesce(new.user_id, old.user_id);
begin
  update public.profiles p
     set pages_written   = (select count(*) from public.diary_entries d where d.user_id = alvo),
         rewards_unlocked = (select count(*) / 5 from public.diary_entries d where d.user_id = alvo)
   where p.id = alvo;
  return null;
end;
$$ language plpgsql security definer;

drop trigger if exists trg_recontar_paginas on public.diary_entries;
create trigger trg_recontar_paginas
  after insert or delete on public.diary_entries
  for each row execute procedure public.recontar_paginas();

-- ------------------------------------------------------------
-- 7) Feed com contagens prontas, para não fazer N consultas
-- ------------------------------------------------------------
create or replace view public.feed_publico as
select
  e.id, e.user_id, e.titulo, e.conteudo_rico, e.data_pagina,
  e.comentarios_on, e.created_at,
  coalesce(p.nome, 'Anônima') as autora,
  (select count(*) from public.entry_likes    l where l.entry_id = e.id) as curtidas,
  (select count(*) from public.entry_comments c where c.entry_id = e.id and not c.oculto) as comentarios
from public.diary_entries e
left join public.profiles p on p.id = e.user_id
where e.is_public = true;
