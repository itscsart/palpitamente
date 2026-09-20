-- ============================================================
-- PAUSA PARA MIM — post rápido na comunidade
-- Rode no SQL Editor DEPOIS do schema-v2.sql.
-- ============================================================

-- Separa página de diário de post rápido da comunidade.
-- Sem isso, um post de duas linhas contaria como página escrita
-- e liberaria recompensa à toa.
alter table public.diary_entries
  add column if not exists tipo text not null default 'pagina'
    check (tipo in ('pagina','post'));

create index if not exists idx_entradas_tipo on public.diary_entries (user_id, tipo);

-- O contador passa a considerar só as páginas de verdade
create or replace function public.recontar_paginas()
returns trigger as $$
declare
  alvo uuid := coalesce(new.user_id, old.user_id);
  total integer;
begin
  select count(*) into total
    from public.diary_entries d
   where d.user_id = alvo and d.tipo = 'pagina';

  update public.profiles p
     set pages_written    = total,
         rewards_unlocked = total / 5
   where p.id = alvo;
  return null;
end;
$$ language plpgsql security definer;

-- A view do feed passa a informar o tipo, para a interface diferenciar
drop view if exists public.feed_publico;
create view public.feed_publico as
select
  e.id, e.user_id, e.titulo, e.conteudo_rico, e.data_pagina, e.tipo,
  e.comentarios_on, e.created_at,
  coalesce(p.nome, 'Anônima') as autora,
  (select count(*) from public.entry_likes    l where l.entry_id = e.id) as curtidas,
  (select count(*) from public.entry_comments c where c.entry_id = e.id and not c.oculto) as comentarios
from public.diary_entries e
left join public.profiles p on p.id = e.user_id
where e.is_public = true;

-- Recalcula o contador de quem já tem páginas salvas
update public.profiles p
   set pages_written    = sub.n,
       rewards_unlocked = sub.n / 5
  from (select user_id, count(*) as n
          from public.diary_entries
         where tipo = 'pagina'
         group by user_id) sub
 where p.id = sub.user_id;
