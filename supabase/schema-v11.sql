-- ============================================================
-- Todos os textos da página Diário Digital editáveis pelo painel
-- Rode no SQL Editor DEPOIS do schema-v10.sql.
-- ============================================================

insert into public.config_site (chave, valor, rotulo, grupo, tipo, ordem) values
  ('venda_etiqueta',      'Diário digital',
     'Etiqueta acima do nome', 'Diário Digital', 'texto', 1),
  ('item_1', 'Diário digital personalizável',
     'Cartão de preço: item 1', 'Diário Digital', 'texto', 10),
  ('item_2', 'Cartela de stickers para usar nas páginas',
     'Cartão de preço: item 2', 'Diário Digital', 'texto', 11),
  ('item_3', 'Área de desenhos para criadoras',
     'Cartão de preço: item 3', 'Diário Digital', 'texto', 12),
  ('item_4', 'Recompensas a cada 5 páginas escritas',
     'Cartão de preço: item 4', 'Diário Digital', 'texto', 13),
  ('item_5', 'Modo privado ou público para compartilhar',
     'Cartão de preço: item 5', 'Diário Digital', 'texto', 14),
  ('botao_comprar', 'Quero meu diário',
     'Texto do botão de compra', 'Diário Digital', 'texto', 15),

  ('beneficio_1_titulo', 'Escreva no seu ritmo',
     'Bloco 01: título', 'Diário Digital', 'texto', 20),
  ('beneficio_1_texto',  'Sem pressão, sem regras rígidas, o diário se adapta ao seu momento e ao seu jeito de contar sua história.',
     'Bloco 01: texto', 'Diário Digital', 'texto_longo', 21),
  ('beneficio_2_titulo', 'Desbloqueie recompensas',
     'Bloco 02: título', 'Diário Digital', 'texto', 22),
  ('beneficio_2_texto',  'A cada 5 páginas escritas, uma nova recompensa é liberada.',
     'Bloco 02: texto', 'Diário Digital', 'texto_longo', 23),
  ('beneficio_3_titulo', 'Faça parte da comunidade',
     'Bloco 03: título', 'Diário Digital', 'texto', 24),
  ('beneficio_3_texto',  'Torne suas reflexões públicas se quiser e troque vivências com outras mulheres da comunidade Palpitamente.',
     'Bloco 03: texto', 'Diário Digital', 'texto_longo', 25)
on conflict (chave) do nothing;

-- ordem dos campos que já existiam, para a aba ficar na sequência da página
update public.config_site set ordem = 0  where chave = 'diario_nome';
update public.config_site set ordem = 2  where chave = 'diario_titulo';
update public.config_site set ordem = 3  where chave = 'diario_descricao';
update public.config_site set ordem = 4  where chave = 'diario_capa';
update public.config_site set ordem = 8  where chave = 'preco_atual';
update public.config_site set ordem = 9  where chave = 'preco_antigo';

select ordem, chave, rotulo from public.config_site
 where grupo = 'Diário Digital' order by ordem;
