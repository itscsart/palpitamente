/* ============================================================
   PACOTES DE STICKERS DA EQUIPE

   Para publicar um pacote novo:
   1. Coloque os arquivos PNG em assets/stickers/
      (fundo transparente, 400x400 px, até 150 KB cada)
   2. Acrescente um objeto na lista abaixo

   Campos:
     nome       -> aparece como título do pacote no painel
     liberadoEm -> a partir de quantas páginas escritas ele aparece.
                   Use 0 para liberar para todas desde o começo.
     arquivos   -> nomes dos arquivos dentro de assets/stickers/
   ============================================================ */

const PACOTES_EQUIPE = [
  // Exemplo, é só descomentar e trocar pelos arquivos reais:
  // {
  //   nome: 'Palpitamente',
  //   liberadoEm: 0,
  //   arquivos: ['coracao-rosa.png', 'xicara.png', 'microfone.png', 'livro.png']
  // },
  // {
  //   nome: 'Verão',
  //   liberadoEm: 20,
  //   arquivos: ['sol.png', 'oculos.png', 'sorvete.png']
  // }
];

function pacotesLiberados(paginasEscritas) {
  return PACOTES_EQUIPE.filter(p => paginasEscritas >= (p.liberadoEm || 0));
}

function caminhoSticker(arquivo) {
  return `assets/stickers/${arquivo}`;
}
