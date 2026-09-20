-- ============================================================
-- Sobre nós editável pelo painel
-- Rode no SQL Editor DEPOIS do schema-v7.sql.
-- ============================================================

insert into public.config_site (chave, valor, rotulo, grupo, tipo, ordem) values
  ('sobre_capa_titulo',   'Cinco mulheres, uma conversa, vários pontos',
     'Título da faixa verde', 'Sobre nós', 'texto', 1),
  ('sobre_capa_sub',      'Conheça a história por trás do Palpitamente e o que nos move todos os dias.',
     'Frase abaixo do título', 'Sobre nós', 'texto_longo', 2),

  ('sobre_p1', 'O Palpitamente nasceu da amizade entre cinco mulheres, de idades e vivências diferentes, com uma vontade em comum, criar um espaço onde mulheres possam conversar sobre tudo aquilo que faz parte da vida.',
     'Parágrafo 1', 'Sobre nós', 'texto_longo', 3),
  ('sobre_p2', 'Por aqui, falamos sobre saúde mental no dia a dia, carreira, relacionamentos, família, amizades, cultura pop, músicas, filmes, séries e tantos outros assuntos que passam pela nossa cabeça.',
     'Parágrafo 2', 'Sobre nós', 'texto_longo', 4),
  ('sobre_p3', 'A ideia é simples: falar sobre a vida como ela é. Dos assuntos mais leves aos mais sérios, sempre com bom humor, troca, acolhimento e espaço para diferentes opiniões.',
     'Parágrafo 3', 'Sobre nós', 'texto_longo', 5),
  ('sobre_p4', 'Mais do que um podcast, queremos construir uma comunidade onde toda mulher possa se identificar, participar e também dar o seu palpite.',
     'Parágrafo 4', 'Sobre nós', 'texto_longo', 6),

  ('guia_titulo', 'O que nos guia',  'Título do cartão lateral', 'Sobre nós', 'texto', 7),
  ('guia_1', 'Conversas reais, sem filtro',        'Cartão: item 1', 'Sobre nós', 'texto', 8),
  ('guia_2', 'Acolhimento acima de julgamento',    'Cartão: item 2', 'Sobre nós', 'texto', 9),
  ('guia_3', 'Espaço para todas as opiniões',      'Cartão: item 3', 'Sobre nós', 'texto', 10),
  ('guia_4', 'Comunidade antes de audiência',      'Cartão: item 4', 'Sobre nós', 'texto', 11),
  ('guia_5', 'Saúde mental feminina no centro',    'Cartão: item 5', 'Sobre nós', 'texto', 12),

  ('equipe_titulo', 'Que faz parte do Palpitamente?', 'Título da faixa rosa', 'Sobre nós', 'texto', 13),
  ('nome_1', 'Camila',  'Nome da 1ª integrante', 'Sobre nós', 'texto', 14),
  ('nome_2', 'Laura',   'Nome da 2ª integrante', 'Sobre nós', 'texto', 15),
  ('nome_3', 'Livia',   'Nome da 3ª integrante', 'Sobre nós', 'texto', 16),
  ('nome_4', 'Mara',    'Nome da 4ª integrante', 'Sobre nós', 'texto', 17),
  ('nome_5', 'Vitória', 'Nome da 5ª integrante', 'Sobre nós', 'texto', 18)
on conflict (chave) do nothing;
