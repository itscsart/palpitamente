-- ============================================================
-- Nome do produto e capa do diário
-- Rode no SQL Editor DEPOIS do schema-v9.sql.
-- ============================================================

-- O painel passa a aceitar campos de imagem, guardados em base64
alter table public.config_site drop constraint if exists config_site_tipo_check;
alter table public.config_site add constraint config_site_tipo_check
  check (tipo in ('texto','texto_longo','link','imagem'));

insert into public.config_site (chave, valor, rotulo, grupo, tipo, ordem) values
  ('diario_nome', 'Pausa para Mim', 'Nome do produto (título grande)', 'Diário Digital', 'texto', 0),
  ('diario_capa', '', 'Capa do diário (imagem)', 'Diário Digital', 'imagem', 5)
on conflict (chave) do nothing;

-- o texto que era título vira subtítulo
update public.config_site
   set rotulo = 'Subtítulo (abaixo do nome)'
 where chave = 'diario_titulo';

select chave, rotulo, tipo, ordem from public.config_site
 where grupo = 'Diário Digital' order by ordem;
