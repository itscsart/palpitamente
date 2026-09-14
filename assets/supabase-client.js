// ============================================================
// CONFIGURAÇÃO DO SUPABASE
// Troque as duas linhas abaixo pelas suas chaves (Settings > API no Supabase)
// ============================================================
const SUPABASE_URL = "COLE_AQUI_SUA_SUPABASE_URL";
const SUPABASE_ANON_KEY = "COLE_AQUI_SUA_ANON_KEY";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ------------------------------------------------------------
// Helpers de autenticação usados nas páginas
// ------------------------------------------------------------
async function getUsuarioLogado() {
  const { data: { user } } = await supabaseClient.auth.getUser();
  return user;
}

async function exigirLogin(redirectPara = "login.html") {
  const user = await getUsuarioLogado();
  if (!user) {
    window.location.href = redirectPara;
    return null;
  }
  return user;
}

async function logout() {
  await supabaseClient.auth.signOut();
  window.location.href = "login.html";
}

async function getPerfil(userId) {
  const { data, error } = await supabaseClient
    .from("profiles")
    .select("*")
    .eq("id", userId)
    .single();
  if (error) { console.error(error); return null; }
  return data;
}
