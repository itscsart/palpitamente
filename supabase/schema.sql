-- ============================================================
-- PALPITAMENTE — Esquema do banco (rodar no SQL Editor do Supabase)
-- ============================================================

-- Perfil do usuário (estende auth.users)
create table if not exists public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  nome text,
  has_diary boolean default false,          -- vira true quando "compra" o diário
  pages_written integer default 0,          -- quantas páginas ela já escreveu
  rewards_unlocked integer default 0,       -- quantas recompensas já desbloqueou
  created_at timestamp with time zone default now()
);

-- Entradas do diário
create table if not exists public.diary_entries (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  content text not null,
  is_public boolean default false,
  social_links jsonb default '{}',          -- {"instagram": "...", "linkedin": "..."}
  created_at timestamp with time zone default now()
);

-- ============================================================
-- Segurança (Row Level Security) — cada usuária só mexe no que é dela
-- ============================================================
alter table public.profiles enable row level security;
alter table public.diary_entries enable row level security;

create policy "Usuária vê e edita o próprio perfil"
  on public.profiles for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "Usuária vê e edita as próprias entradas"
  on public.diary_entries for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Entradas públicas: qualquer usuária logada pode LER as públicas de outras
create policy "Qualquer um pode ler entradas públicas"
  on public.diary_entries for select
  using (is_public = true);

-- ============================================================
-- Cria o perfil automaticamente quando alguém se cadastra
-- ============================================================
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, nome)
  values (new.id, new.raw_user_meta_data->>'nome');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
