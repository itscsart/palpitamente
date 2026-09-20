-- ============================================================
-- Reorganiza as configurações por PÁGINA
-- Rode no SQL Editor DEPOIS do schema-v8.sql.
-- ============================================================

-- Os grupos viram o nome da página onde o texto aparece.
update public.config_site set grupo = 'Home'           where chave in ('hero_titulo','hero_subtitulo');
update public.config_site set grupo = 'Diário Digital' where chave like 'preco%' or chave like 'diario_%';
update public.config_site set grupo = 'Sobre nós'      where chave like 'sobre_%' or chave like 'guia_%'
                                                          or chave like 'nome_%' or chave = 'equipe_titulo';
update public.config_site set grupo = 'Rodapé'         where chave like 'contato_%' or chave like 'rede_%';

-- ordem dentro de cada página
update public.config_site set ordem = 1 where chave = 'contato_email';
update public.config_site set ordem = 2 where chave = 'contato_telefone';
update public.config_site set ordem = 3 where chave = 'rede_instagram';
update public.config_site set ordem = 4 where chave = 'rede_youtube';
update public.config_site set ordem = 5 where chave = 'rede_tiktok';
update public.config_site set ordem = 6 where chave = 'rede_spotify';
update public.config_site set ordem = 7 where chave = 'rede_soundcloud';

select grupo, count(*) as campos from public.config_site group by grupo order by grupo;
