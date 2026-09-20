-- ============================================================
-- PAUSA PARA MIM — respostas e notificações
-- Rode no SQL Editor DEPOIS do schema-v4.sql.
-- ============================================================

-- ------------------------------------------------------------
-- 1) Resposta a comentário (um nível, como Instagram e X)
-- ------------------------------------------------------------
alter table public.entry_comments
  add column if not exists parent_id uuid references public.entry_comments(id) on delete cascade;

create index if not exists idx_comentarios_pai on public.entry_comments (parent_id);

-- ------------------------------------------------------------
-- 2) Notificações
-- ------------------------------------------------------------
create table if not exists public.notificacoes (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,  -- quem recebe
  autor_id    uuid not null references auth.users(id) on delete cascade,  -- quem causou
  tipo        text not null check (tipo in ('comentario','resposta','curtida')),
  entry_id    uuid references public.diary_entries(id) on delete cascade,
  comment_id  uuid references public.entry_comments(id) on delete cascade,
  lida        boolean default false,
  created_at  timestamptz default now()
);
create index if not exists idx_notif_usuaria on public.notificacoes (user_id, lida, created_at desc);

alter table public.notificacoes enable row level security;

drop policy if exists "ver as proprias notificacoes" on public.notificacoes;
create policy "ver as proprias notificacoes"
  on public.notificacoes for select using (auth.uid() = user_id);

drop policy if exists "marcar as proprias como lidas" on public.notificacoes;
create policy "marcar as proprias como lidas"
  on public.notificacoes for update using (auth.uid() = user_id);

drop policy if exists "apagar as proprias notificacoes" on public.notificacoes;
create policy "apagar as proprias notificacoes"
  on public.notificacoes for delete using (auth.uid() = user_id);

-- ------------------------------------------------------------
-- 3) Gatilho: cria a notificação sozinho ao comentar
--    Feito no banco, não no navegador: se ficasse no JS,
--    bastava não chamar a função para ninguém ser avisado.
-- ------------------------------------------------------------
create or replace function public.avisar_comentario()
returns trigger as $$
declare
  dono_pagina uuid;
  dono_pai    uuid;
begin
  select user_id into dono_pagina from public.diary_entries where id = new.entry_id;

  -- avisa a dona da página (se não foi ela mesma que comentou)
  if dono_pagina is not null and dono_pagina <> new.user_id then
    insert into public.notificacoes (user_id, autor_id, tipo, entry_id, comment_id)
    values (dono_pagina, new.user_id,
            case when new.parent_id is null then 'comentario' else 'resposta' end,
            new.entry_id, new.id);
  end if;

  -- avisa quem escreveu o comentário respondido
  if new.parent_id is not null then
    select user_id into dono_pai from public.entry_comments where id = new.parent_id;
    if dono_pai is not null and dono_pai <> new.user_id and dono_pai <> dono_pagina then
      insert into public.notificacoes (user_id, autor_id, tipo, entry_id, comment_id)
      values (dono_pai, new.user_id, 'resposta', new.entry_id, new.id);
    end if;
  end if;

  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists trg_avisar_comentario on public.entry_comments;
create trigger trg_avisar_comentario
  after insert on public.entry_comments
  for each row execute procedure public.avisar_comentario();

-- ------------------------------------------------------------
-- 4) Gatilho: avisa quando alguém curte
-- ------------------------------------------------------------
create or replace function public.avisar_curtida()
returns trigger as $$
declare
  dono_pagina uuid;
begin
  select user_id into dono_pagina from public.diary_entries where id = new.entry_id;
  if dono_pagina is not null and dono_pagina <> new.user_id then
    insert into public.notificacoes (user_id, autor_id, tipo, entry_id)
    values (dono_pagina, new.user_id, 'curtida', new.entry_id);
  end if;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists trg_avisar_curtida on public.entry_likes;
create trigger trg_avisar_curtida
  after insert on public.entry_likes
  for each row execute procedure public.avisar_curtida();

-- ------------------------------------------------------------
-- 5) Nome de quem aparece na notificação
-- ------------------------------------------------------------
drop policy if exists "ler nome de quem publica" on public.profiles;
create policy "ler nome de quem publica"
  on public.profiles for select
  using (
    id = auth.uid()
    or exists (select 1 from public.diary_entries e
               where e.user_id = profiles.id and e.is_public)
    or exists (select 1 from public.entry_comments c
                 join public.diary_entries e on e.id = c.entry_id
                where c.user_id = profiles.id and e.is_public)
    or exists (select 1 from public.notificacoes n
                where n.autor_id = profiles.id and n.user_id = auth.uid())
  );
