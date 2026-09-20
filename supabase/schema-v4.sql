-- ============================================================
-- PAUSA PARA MIM — correções
-- Rode no SQL Editor DEPOIS do schema-v3.sql.
-- ============================================================

-- ------------------------------------------------------------
-- 1) Conta nova já entra com o diário liberado
--    (antes nascia com has_diary = false e caía na página de compra)
-- ------------------------------------------------------------
alter table public.profiles alter column has_diary set default true;

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, nome, has_diary)
  values (new.id, new.raw_user_meta_data->>'nome', true)
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

-- libera para quem já se cadastrou antes desta correção
update public.profiles set has_diary = true where has_diary is distinct from true;

-- ------------------------------------------------------------
-- 2) Nome de quem comenta
--    A política antiga só deixava ler o perfil de quem tem página
--    pública. Quem só comentava aparecia como "Anônima".
-- ------------------------------------------------------------
drop policy if exists "ler nome de quem publica" on public.profiles;
create policy "ler nome de quem publica"
  on public.profiles for select
  using (
    id = auth.uid()
    or exists (select 1 from public.diary_entries e
               where e.user_id = profiles.id and e.is_public)
    or exists (select 1
                 from public.entry_comments c
                 join public.diary_entries e on e.id = c.entry_id
                where c.user_id = profiles.id and e.is_public)
  );
