/* ============================================================
   INDICAÇÕES DO PALPITAMENTE

   Para adicionar uma indicação, acrescente um objeto na lista.
   A página agrupa sozinha por tipo e só mostra os grupos que
   tiverem algo dentro. Então é só ir preenchendo.

   Campos:
     tipo     -> 'livro', 'filme' ou 'serie'
     titulo   -> nome da obra
     autor    -> autor, direção ou criação
     nota     -> uma linha opcional sobre por que vocês indicaram
                 (deixe '' se não quiser escrever nada)
   ============================================================ */

const INDICACOES = [
  { tipo:'livro', titulo:'Margô Está em Apuros',                     autor:'Rufi Thorpe',      nota:'' },
  { tipo:'livro', titulo:'Tudo o Que Eu Sei Sobre o Amor',           autor:'Dolly Alderton',   nota:'' },
  { tipo:'livro', titulo:'Os Abismos',                               autor:'Pilar Quintana',   nota:'' },
  { tipo:'livro', titulo:'Tudo é Rio',                               autor:'Carla Madeira',    nota:'' },
  { tipo:'livro', titulo:'Aurora',                                   autor:'Marcela Ceribelli',nota:'' },
  { tipo:'livro', titulo:'Os Maridos',                               autor:'Holly Gramazio',   nota:'' },
  { tipo:'livro', titulo:'As Bruxas da Noite',                       autor:'Ritanna Armeni',   nota:'' },
  { tipo:'livro', titulo:'Três',                                     autor:'Valérie Perrin',   nota:'' },
  { tipo:'livro', titulo:'Sobre Minha Filha',                        autor:'Kim Hye-jin',      nota:'' },
  { tipo:'livro', titulo:'O Milagre da Manhã',                       autor:'Hal Elrod',        nota:'' },
  { tipo:'livro', titulo:'A Gente Mira no Amor e Acerta na Solidão', autor:'Ana Suy',          nota:'' }

  /* Quando indicarem um filme ou série, é só seguir o mesmo formato:
  , { tipo:'filme', titulo:'Nome do filme', autor:'Direção', nota:'' }
  , { tipo:'serie', titulo:'Nome da série', autor:'Criação', nota:'' }
  */
];

const GRUPOS = [
  { tipo:'livro', titulo:'Para ler',  vazio:'Ainda não indicamos nenhum livro por aqui.' },
  { tipo:'filme', titulo:'Para ver',  vazio:'Ainda não indicamos nenhum filme, mas vem aí.' },
  { tipo:'serie', titulo:'Para maratonar', vazio:'Ainda não indicamos nenhuma série, mas vem aí.' }
];
