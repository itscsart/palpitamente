-- ============================================================
-- PAINEL DE ADMINISTRAÇÃO
-- Tira o conteúdo dos arquivos .js e coloca no banco, para
-- poder editar pelo próprio site.
-- Rode no SQL Editor DEPOIS do schema-v6.sql.
-- ============================================================

-- ------------------------------------------------------------
-- 1) Quem é administradora
-- ------------------------------------------------------------
alter table public.profiles
  add column if not exists is_admin boolean not null default false;

-- ------------------------------------------------------------
-- 2) Episódios
-- ------------------------------------------------------------
create table if not exists public.episodios (
  id          uuid primary key default gen_random_uuid(),
  numero      text not null,
  titulo      text,
  descricao   text,
  duracao     text,
  youtube     text,
  spotify     text,
  soundcloud  text,
  publicado   boolean default false,
  ordem       integer default 0,
  created_at  timestamptz default now()
);

-- ------------------------------------------------------------
-- 3) Indicações
-- ------------------------------------------------------------
create table if not exists public.indicacoes (
  id         uuid primary key default gen_random_uuid(),
  tipo       text not null check (tipo in ('livro','filme','serie')),
  titulo     text not null,
  autor      text,
  genero     text,
  capa       text,                -- URL ou imagem em base64
  nota       text,
  sinopse    text,
  ordem      integer default 0,
  created_at timestamptz default now()
);

-- ------------------------------------------------------------
-- 4) Configurações soltas (preço, textos, links)
-- ------------------------------------------------------------
create table if not exists public.config_site (
  chave      text primary key,
  valor      text,
  rotulo     text,                -- nome amigável no painel
  grupo      text default 'geral',
  tipo       text default 'texto' check (tipo in ('texto','texto_longo','link')),
  ordem      integer default 0
);

-- ------------------------------------------------------------
-- SEGURANÇA
-- Qualquer visitante LÊ. Só administradora ESCREVE.
-- ------------------------------------------------------------
alter table public.episodios   enable row level security;
alter table public.indicacoes  enable row level security;
alter table public.config_site enable row level security;

create or replace function public.eh_admin()
returns boolean as $$
  select coalesce((select is_admin from public.profiles where id = auth.uid()), false);
$$ language sql stable security definer;

do $$
declare t text;
begin
  foreach t in array array['episodios','indicacoes','config_site'] loop
    execute format('drop policy if exists "qualquer um le %1$s" on public.%1$s', t);
    execute format('create policy "qualquer um le %1$s" on public.%1$s for select using (true)', t);

    execute format('drop policy if exists "so admin escreve %1$s" on public.%1$s', t);
    execute format('create policy "so admin escreve %1$s" on public.%1$s for all
                    using (public.eh_admin()) with check (public.eh_admin())', t);
  end loop;
end $$;

-- a própria admin precisa conseguir ler o campo is_admin
drop policy if exists "ler nome de quem publica" on public.profiles;
create policy "ler nome de quem publica"
  on public.profiles for select
  using (
    id = auth.uid()
    or exists (select 1 from public.diary_entries e where e.user_id = profiles.id and e.is_public)
    or exists (select 1 from public.entry_comments c
                 join public.diary_entries e on e.id = c.entry_id
                where c.user_id = profiles.id and e.is_public)
    or exists (select 1 from public.notificacoes n where n.autor_id = profiles.id and n.user_id = auth.uid())
  );

-- ------------------------------------------------------------
-- 5) Conteúdo que já existe hoje nos arquivos .js
-- ------------------------------------------------------------
insert into public.episodios (numero, titulo, descricao, duracao, youtube, publicado, ordem)
select '01', 'Nosso primeiro palpite',
       'O episódio de estreia, onde a gente se apresenta e conta como o Palpitamente nasceu.',
       '30 Min', 'VUO2XyGrVpw', true, 1
where not exists (select 1 from public.episodios);

insert into public.episodios (numero, publicado, ordem)
select * from (values ('02', false, 2), ('03', false, 3)) as v(numero, publicado, ordem)
where (select count(*) from public.episodios) < 3;

insert into public.indicacoes (tipo, titulo, autor, genero, ordem)
select * from (values
  ('livro','Margô Está em Apuros','Rufi Thorpe','Ficção contemporânea',1),
  ('livro','Tudo o Que Eu Sei Sobre o Amor','Dolly Alderton','Memórias',2),
  ('livro','Os Abismos','Pilar Quintana','Ficção literária',3),
  ('livro','Tudo é Rio','Carla Madeira','Ficção literária',4),
  ('livro','Aurora','Marcela Ceribelli','Ficção contemporânea',5),
  ('livro','Os Maridos','Holly Gramazio','Realismo mágico',6),
  ('livro','As Bruxas da Noite','Ritanna Armeni','Ficção histórica',7),
  ('livro','Três','Valérie Perrin','Ficção literária',8),
  ('livro','Sobre Minha Filha','Kim Hye-jin','Ficção literária',9),
  ('livro','O Milagre da Manhã','Hal Elrod','Desenvolvimento pessoal',10),
  ('livro','A Gente Mira no Amor e Acerta na Solidão','Ana Suy','Psicanálise',11)
) as v(tipo, titulo, autor, genero, ordem)
where not exists (select 1 from public.indicacoes);

insert into public.config_site (chave, valor, rotulo, grupo, tipo, ordem) values
  ('preco_atual',      'R$ 0,00',                          'Preço do diário',            'Diário Digital','texto',1),
  ('preco_antigo',     '',                                 'Preço riscado (opcional)',   'Diário Digital','texto',2),
  ('diario_titulo',    'Um espaço só seu para escrever',   'Título da página',           'Diário Digital','texto',3),
  ('diario_descricao', 'Frases motivacionais, stickers, área de rabisco livre e um sistema de recompensas que te incentiva a criar o hábito de escrever sobre a sua vida.',
                                                           'Descrição',                  'Diário Digital','texto_longo',4),
  ('hero_titulo',      'Conversas reais sobre tudo o que passa pela nossa cabeça',
                                                           'Título do carrossel',        'Home','texto_longo',1),
  ('hero_subtitulo',   'Um podcast para quem pensa demais, mas não pensa sozinha.',
                                                           'Subtítulo do carrossel',     'Home','texto_longo',2),
  ('contato_email',    'contato@palpitamente.com',         'E-mail de contato',          'Contato','texto',1),
  ('contato_telefone', '(11) 95789-5463',                  'Telefone',                   'Contato','texto',2),
  ('rede_instagram',   'https://www.instagram.com/palpitamente',                'Instagram','Redes','link',1),
  ('rede_youtube',     'https://www.youtube.com/@PalpitamentePodcast',          'YouTube',  'Redes','link',2),
  ('rede_tiktok',      'https://www.tiktok.com/@palpitamente',                  'TikTok',   'Redes','link',3),
  ('rede_spotify',     'https://open.spotify.com/show/4Nqvxvfy1jntHZeC2VltgI',  'Spotify',  'Redes','link',4),
  ('rede_soundcloud',  'https://on.soundcloud.com/6PZZUpQEnQgUUDeTgH',          'SoundCloud','Redes','link',5)
on conflict (chave) do nothing;

-- ------------------------------------------------------------
-- 6) QUEM TEM ACESSO AO PAINEL
--
--    ATENÇÃO: a conta precisa JÁ EXISTIR no site. Cadastre o
--    e-mail em login.html antes de rodar esta parte, senão o
--    comando não encontra ninguém e não faz nada.
--
--    Para liberar mais gente depois, use a aba "Equipe" do
--    próprio painel. Não precisa voltar aqui.
-- ------------------------------------------------------------
update public.profiles set is_admin = true
 where id in (
   select id from auth.users
    where lower(email) in (
      'palpitamente@gmail.com',
      'contato.camilapaivasouza@gmail.com'
      -- acrescente outros e-mails aqui, um por linha, com vírgula
    )
 );

-- Confira o resultado: deve listar quem virou administradora.
-- Se voltar vazio, a conta ainda não existe no site.
select u.email, p.nome, p.is_admin
  from public.profiles p
  join auth.users u on u.id = p.id
 where p.is_admin = true;

-- ------------------------------------------------------------
-- 7) Dar e tirar acesso pelo painel, buscando pelo e-mail
--    A tabela auth.users não é acessível pelo navegador, então
--    a busca acontece aqui dentro, e só quem já é admin pode usar.
-- ------------------------------------------------------------
create or replace function public.definir_admin(alvo_email text, liberar boolean)
returns boolean as $$
declare
  alvo uuid;
begin
  if not public.eh_admin() then
    raise exception 'Só quem já tem acesso pode liberar outras pessoas.';
  end if;

  select id into alvo from auth.users where lower(email) = lower(alvo_email);
  if alvo is null then
    return false;                      -- não existe conta com esse e-mail
  end if;

  update public.profiles set is_admin = liberar where id = alvo;
  return true;
end;
$$ language plpgsql security definer;

revoke all on function public.definir_admin(text, boolean) from public;
grant execute on function public.definir_admin(text, boolean) to authenticated;
