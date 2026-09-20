/* ============================================================
   LISTA DE EPISÓDIOS DO PALPITAMENTE

   Para publicar um episódio novo, basta adicionar um objeto
   no topo da lista abaixo. A home mostra os três primeiros e
   a página de episódios mostra todos.

   Campos:
     numero    -> aparece na tag (#01, #02...)
     titulo    -> nome do episódio
     descricao -> uma linha curta, aparece na página de episódios
     duracao   -> texto livre ("30 Min")
     youtube   -> ID do vídeo. Na URL
                  https://www.youtube.com/watch?v=ABC123xyz
                  o ID é ABC123xyz
     spotify   -> link completo (deixe "" enquanto não houver)
     soundcloud-> link completo (deixe "" enquanto não houver)
     publicado -> true  = episódio no ar
                  false = card de "lançamento em breve"
   ============================================================ */

const EPISODIOS = [
  {
    numero: '01',
    titulo: 'Nosso primeiro palpite',
    descricao: 'O episódio de estreia, onde a gente se apresenta e conta como o Palpitamente nasceu.',
    duracao: '30 Min',
    youtube: 'VUO2XyGrVpw',
    spotify: '',
    soundcloud: '',
    publicado: true
  },
  {
    numero: '02',
    titulo: '',
    descricao: '',
    duracao: '',
    youtube: '',
    spotify: '',
    soundcloud: '',
    publicado: false
  },
  {
    numero: '03',
    titulo: '',
    descricao: '',
    duracao: '',
    youtube: '',
    spotify: '',
    soundcloud: '',
    publicado: false
  }
];

/* capa do episódio: usa a miniatura do próprio YouTube */
function capaDoEpisodio(ep) {
  if (!ep.publicado || !ep.youtube || ep.youtube.startsWith('COLE_AQUI')) return null;
  return `https://img.youtube.com/vi/${ep.youtube}/hqdefault.jpg`;
}

function linkDoEpisodio(ep) {
  if (!ep.publicado || !ep.youtube || ep.youtube.startsWith('COLE_AQUI')) return null;
  return `https://www.youtube.com/watch?v=${ep.youtube}`;
}
