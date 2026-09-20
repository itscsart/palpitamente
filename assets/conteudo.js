/* ============================================================
   PONTE ENTRE O SITE E O BANCO

   As páginas públicas passaram a ler episódios, indicações e
   textos do Supabase, para tudo ser editável pelo painel.

   Se o banco não responder, o site cai nos arquivos antigos
   (episodios.js e indicacoes.js) em vez de ficar vazio.
   ============================================================ */

async function buscarEpisodios(){
  try {
    const { data, error } = await supabaseClient
      .from('episodios').select('*').order('ordem');
    if (error || !data || !data.length) throw new Error('sem dados');
    return data;
  } catch(_) {
    return (typeof EPISODIOS !== 'undefined') ? EPISODIOS : [];
  }
}

async function buscarIndicacoes(){
  try {
    const { data, error } = await supabaseClient
      .from('indicacoes').select('*').order('ordem');
    if (error || !data || !data.length) throw new Error('sem dados');
    return data;
  } catch(_) {
    return (typeof INDICACOES !== 'undefined') ? INDICACOES : [];
  }
}

async function buscarConfig(){
  try {
    const { data, error } = await supabaseClient.from('config_site').select('chave, valor');
    if (error || !data) throw new Error('sem dados');
    const mapa = {};
    data.forEach(c => { mapa[c.chave] = c.valor; });
    return mapa;
  } catch(_) { return {}; }
}

/* aplica os textos configuráveis nos elementos marcados com data-config */
async function aplicarConfig(){
  const cfg = await buscarConfig();
  document.querySelectorAll('[data-config]').forEach(el => {
    const v = cfg[el.dataset.config];
    if (v === undefined || v === null || v === '') return;
    if (el.tagName === 'A' && el.dataset.configAlvo === 'href') el.href = v;
    else el.textContent = v;
  });
  document.querySelectorAll('[data-config-href]').forEach(el => {
    const v = cfg[el.dataset.configHref];
    if (v) el.href = v;
  });
  return cfg;
}

/* capa do episódio a partir do YouTube */
function capaDoEpisodio(ep){
  if (!ep.publicado || !ep.youtube) return null;
  return `https://img.youtube.com/vi/${ep.youtube}/hqdefault.jpg`;
}
function linkDoEpisodio(ep){
  if (!ep.publicado || !ep.youtube) return null;
  return `https://www.youtube.com/watch?v=${ep.youtube}`;
}
function capaDaIndicacao(item){
  if (!item.capa) return null;
  return item.capa.startsWith('data:') || item.capa.startsWith('http')
    ? item.capa
    : `assets/capas/${item.capa}`;
}

/* mostra o atalho do painel só para quem é da equipe */
(async function mostrarAtalhoPainel(){
  const link = document.getElementById('linkPainel');
  if (!link || typeof getUsuarioLogado !== 'function') return;
  try {
    const u = await getUsuarioLogado();
    if (!u) return;
    const { data } = await supabaseClient.from('profiles').select('is_admin').eq('id', u.id).single();
    if (data?.is_admin) link.hidden = false;
  } catch(_) {}
})();
