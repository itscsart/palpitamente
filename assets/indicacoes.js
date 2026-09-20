/* ============================================================
   INDICAÇÕES DO PALPITAMENTE

   COMO ADICIONAR UMA INDICAÇÃO
   Acrescente um objeto na lista INDICACOES abaixo.

   Campos:
     tipo    -> 'livro', 'filme' ou 'serie'
     titulo  -> nome da obra
     autor   -> autor (livro) / direção (filme) / criação (série)
     genero  -> escolha um da lista de gêneros correspondente ao
                tipo (GENEROS_LIVRO ou GENEROS_TELA, mais abaixo).
                Escreva exatamente igual, com acento e maiúscula.
     capa    -> nome do arquivo dentro de assets/capas/
                ex.: 'tudo-e-rio.jpg'. Vale para livro, filme e série.
                Deixe '' se ainda não tiver: entra um símbolo no lugar.
     sinopse -> descrição da obra. Aparece quando a usuária clica
                no card. Pode ter vários parágrafos.
     nota    -> uma linha opcional de vocês sobre a indicação

   O filtro é montado sozinho e só mostra os gêneros que tiverem
   pelo menos uma obra, na ordem das listas abaixo.
   ============================================================ */

/* ---------- gêneros aceitos para LIVROS ---------- */
const GENEROS_LIVRO = [
  'Romance', 'Romance contemporâneo', 'Romance histórico', 'Comédia romântica',
  'Drama', 'Ficção contemporânea', 'Ficção literária', 'Ficção histórica',
  'Fantasia', 'Fantasia romântica', 'Ficção científica', 'Distopia',
  'Suspense', 'Thriller', 'Mistério', 'Terror', 'Policial', 'Aventura',
  'Realismo mágico', 'Crônicas', 'Contos', 'Poesia',
  'Biografia', 'Autobiografia', 'Memórias', 'Ensaio', 'Não ficção',
  'Desenvolvimento pessoal', 'Psicologia', 'Filosofia', 'História',
  'True crime', 'Young Adult (YA)', 'New Adult', 'Psicanálise', 'Autoajuda'
];

/* ---------- gêneros aceitos para FILMES e SÉRIES ---------- */
const GENEROS_TELA = [
  'Romance', 'Comédia', 'Comédia romântica', 'Drama', 'Ação', 'Aventura',
  'Suspense', 'Thriller', 'Terror', 'Mistério', 'Policial', 'Crime',
  'Ficção científica', 'Fantasia', 'Distopia', 'Histórico', 'Biográfico',
  'Documentário', 'Musical', 'Animação', 'Família', 'Western', 'Guerra',
  'Esporte', 'Super-heróis', 'Investigação',
  'Drama psicológico', 'Drama familiar', 'Drama adolescente', 'Coming of age',
  'Sitcom', 'Reality show', 'True crime', 'Antologia', 'Romance de época',
  'Fantasia sombria', 'Sobrenatural', 'Pós-apocalíptico', 'Ficção política',
  'Sátira', 'Mockumentary'
];

const INDICACOES = [
  { tipo:'livro', titulo:'Margô Está em Apuros', autor:'Rufi Thorpe',
    genero:'Ficção contemporânea', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'Tudo o Que Eu Sei Sobre o Amor', autor:'Dolly Alderton',
    genero:'Memórias', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'Os Abismos', autor:'Pilar Quintana',
    genero:'Ficção literária', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'Tudo é Rio', autor:'Carla Madeira',
    genero:'Ficção literária', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'Aurora', autor:'Marcela Ceribelli',
    genero:'Ficção contemporânea', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'Os Maridos', autor:'Holly Gramazio',
    genero:'Realismo mágico', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'As Bruxas da Noite', autor:'Ritanna Armeni',
    genero:'Ficção histórica', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'Três', autor:'Valérie Perrin',
    genero:'Ficção literária', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'Sobre Minha Filha', autor:'Kim Hye-jin',
    genero:'Ficção literária', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'O Milagre da Manhã', autor:'Hal Elrod',
    genero:'Desenvolvimento pessoal', capa:'', nota:'', sinopse:'' },

  { tipo:'livro', titulo:'A Gente Mira no Amor e Acerta na Solidão', autor:'Ana Suy',
    genero:'Psicanálise', capa:'', nota:'', sinopse:'' }

  /* Exemplos para quando indicarem filme ou série:
  , { tipo:'filme', titulo:'Nome do filme', autor:'Direção de Fulana',
      genero:'Drama', capa:'nome-do-arquivo.jpg', nota:'', sinopse:'' }
  , { tipo:'serie', titulo:'Nome da série', autor:'Criação de Fulana',
      genero:'Coming of age', capa:'', nota:'', sinopse:'' }
  */
];

const GRUPOS = [
  { tipo:'livro', titulo:'Para ler',       rotulo:'Autoria',  vazio:'Ainda não indicamos nenhum livro por aqui.' },
  { tipo:'filme', titulo:'Para ver',       rotulo:'Direção',  vazio:'Ainda não indicamos nenhum filme, mas vem aí.' },
  { tipo:'serie', titulo:'Para maratonar', rotulo:'Criação',  vazio:'Ainda não indicamos nenhuma série, mas vem aí.' }
];

/* caminho da capa, ou null quando ainda nao ha imagem */
function capaDaIndicacao(item) {
  return item.capa ? `assets/capas/${item.capa}` : null;
}

/* generos em uso num tipo, na ordem da lista oficial */
function generosDoTipo(tipo) {
  const oficial = (tipo === 'livro') ? GENEROS_LIVRO : GENEROS_TELA;
  const usados = new Set(INDICACOES.filter(i => i.tipo === tipo).map(i => i.genero));
  const naLista = oficial.filter(g => usados.has(g));
  // se alguem escrever um genero fora da lista, ele ainda aparece no fim
  const fora = [...usados].filter(g => g && !oficial.includes(g));
  return [...naLista, ...fora];
}
