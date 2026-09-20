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

/* Aplica as configurações em TODA página que carregar este arquivo.
   Antes isso dependia de cada página chamar aplicarConfig() por conta
   própria, e a de produtos não chamava: o preço nunca atualizava. */
document.addEventListener('DOMContentLoaded', aplicarConfig);
if (document.readyState !== 'loading') aplicarConfig();

/* Atalho do painel: só aparece depois de confirmar, no banco, que a
   conta logada é administradora. Visitante deslogado nunca vê. */
(async function mostrarAtalhoPainel(){
  const link = document.getElementById('linkPainel');
  if (!link) return;
  link.hidden = true;                       // parte escondido, sempre
  if (typeof getUsuarioLogado !== 'function') return;
  try {
    const u = await getUsuarioLogado();
    if (!u) return;
    const { data, error } = await supabaseClient
      .from('profiles').select('is_admin').eq('id', u.id).single();
    if (!error && data && data.is_admin === true) link.hidden = false;
  } catch(_) { /* na dúvida, continua escondido */ }
})();

/* ---------- voltar ao topo ----------
   Espera o DOM ficar pronto: o botão fica no fim do corpo, depois
   das tags de script, então na hora que este arquivo roda ele ainda
   não existe. */
function ligarAoTopo(){
  const bt = document.getElementById('aoTopo');
  if (!bt) return;
  const conferir = () => bt.classList.toggle('visivel', window.scrollY > 400);
  window.addEventListener('scroll', conferir, { passive:true });
  conferir();
  bt.addEventListener('click', () => {
    const suave = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    window.scrollTo({ top:0, behavior: suave ? 'smooth' : 'auto' });
  });
}
if (document.readyState === 'loading')
  document.addEventListener('DOMContentLoaded', ligarAoTopo);
else ligarAoTopo();
