/* ============================================================
   INDICAÇÕES DO PALPITAMENTE

   Para adicionar uma indicação, acrescente um objeto na lista.
   A página agrupa por tipo e monta os filtros de gênero sozinha,
   a partir do que estiver escrito aqui.

   Campos:
     tipo    -> 'livro', 'filme' ou 'serie'
     titulo  -> nome da obra
     autor   -> autor, direção ou criação
     genero  -> usado no filtro. Escreva sempre igual entre as obras
                do mesmo gênero, senão vira dois botões diferentes.
     capa    -> nome do arquivo dentro de assets/capas/
                (ex.: 'tudo-e-rio.jpg'). Deixe '' se ainda não
                tiver a imagem: entra um cartão com o título.
     nota    -> uma linha opcional sobre por que vocês indicaram
   ============================================================ */

const INDICACOES = [
  { tipo:'livro', titulo:'Margô Está em Apuros',                     autor:'Rufi Thorpe',       genero:'Ficção contemporânea',    capa:'', nota:'' },
  { tipo:'livro', titulo:'Tudo o Que Eu Sei Sobre o Amor',           autor:'Dolly Alderton',    genero:'Memórias',                capa:'', nota:'' },
  { tipo:'livro', titulo:'Os Abismos',                               autor:'Pilar Quintana',    genero:'Ficção literária',        capa:'', nota:'' },
  { tipo:'livro', titulo:'Tudo é Rio',                               autor:'Carla Madeira',     genero:'Ficção brasileira',       capa:'', nota:'' },
  { tipo:'livro', titulo:'Aurora',                                   autor:'Marcela Ceribelli', genero:'Ficção brasileira',       capa:'', nota:'' },
  { tipo:'livro', titulo:'Os Maridos',                               autor:'Holly Gramazio',    genero:'Ficção contemporânea',    capa:'', nota:'' },
  { tipo:'livro', titulo:'As Bruxas da Noite',                       autor:'Ritanna Armeni',    genero:'Histórico',               capa:'', nota:'' },
  { tipo:'livro', titulo:'Três',                                     autor:'Valérie Perrin',    genero:'Ficção literária',        capa:'', nota:'' },
  { tipo:'livro', titulo:'Sobre Minha Filha',                        autor:'Kim Hye-jin',       genero:'Ficção literária',        capa:'', nota:'' },
  { tipo:'livro', titulo:'O Milagre da Manhã',                       autor:'Hal Elrod',         genero:'Desenvolvimento pessoal', capa:'', nota:'' },
  { tipo:'livro', titulo:'A Gente Mira no Amor e Acerta na Solidão', autor:'Ana Suy',           genero:'Psicanálise',             capa:'', nota:'' }

  /* Quando indicarem um filme ou série, é só seguir o mesmo formato:
  , { tipo:'filme', titulo:'Nome do filme', autor:'Direção', genero:'Drama', capa:'', nota:'' }
  , { tipo:'serie', titulo:'Nome da série', autor:'Criação', genero:'Drama', capa:'', nota:'' }
  */
];

const GRUPOS = [
  { tipo:'livro', titulo:'Para ler',       vazio:'Ainda não indicamos nenhum livro por aqui.' },
  { tipo:'filme', titulo:'Para ver',       vazio:'Ainda não indicamos nenhum filme, mas vem aí.' },
  { tipo:'serie', titulo:'Para maratonar', vazio:'Ainda não indicamos nenhuma série, mas vem aí.' }
];

/* caminho da capa, ou null quando ainda nao ha imagem */
function capaDaIndicacao(item) {
  return item.capa ? `assets/capas/${item.capa}` : null;
}

/* generos presentes em um tipo, em ordem alfabetica */
function generosDoTipo(tipo) {
  return [...new Set(INDICACOES.filter(i => i.tipo === tipo).map(i => i.genero).filter(Boolean))]
    .sort((a, b) => a.localeCompare(b, 'pt-BR'));
}
