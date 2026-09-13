# Palpitamente — Protótipo navegável (Vercel + Supabase)

Site estático (HTML puro) com login e diário funcionando de verdade via Supabase.
Sem pagamento real — o botão "Quero meu diário" apenas libera o acesso no seu usuário.

## Estrutura
```
palpitamente-site/
├── index.html          → Home
├── sobre.html          → Sobre nós
├── produtos.html       → Produtos (compra "fake" do diário)
├── login.html          → Entrar / Criar conta
├── diario.html         → Diário (protegido por login)
├── assets/
│   ├── style.css
│   ├── supabase-client.js   ← você vai colar suas chaves aqui
│   ├── logo-cor.png
│   ├── logo-branco.png
│   └── grain.png
├── supabase/
│   └── schema.sql       → rodar isso no Supabase antes de tudo
└── vercel.json
```

## Passo 1 — Criar o projeto no Supabase
1. Acesse https://supabase.com e crie uma conta (pode ser com GitHub).
2. Clique em **New Project**. Escolha um nome (ex: `palpitamente`) e uma senha de banco (guarde essa senha).
3. Espere o projeto terminar de subir (leva ~2 minutos).
4. No menu lateral, vá em **SQL Editor** → **New query**.
5. Abra o arquivo `supabase/schema.sql` deste projeto, copie todo o conteúdo, cole no editor e clique em **Run**.
6. Vá em **Authentication → Providers** e confirme que **Email** está habilitado.
   - Opcional (recomendado para o dia da apresentação): em **Authentication → Providers → Email**, desative "Confirm email" para não depender de e-mail real durante a demo.
7. Vá em **Settings → API**. Copie:
   - **Project URL**
   - **anon public key**

## Passo 2 — Colar as chaves no projeto
Abra `assets/supabase-client.js` e troque:
```js
const SUPABASE_URL = "COLE_AQUI_SUA_SUPABASE_URL";
const SUPABASE_ANON_KEY = "COLE_AQUI_SUA_ANON_KEY";
```
pelos valores que você copiou.

## Passo 3 — Subir para o GitHub
1. Crie um repositório novo no GitHub (ex: `palpitamente-site`).
2. Envie esta pasta inteira para o repositório:
```bash
cd palpitamente-site
git init
git add .
git commit -m "Primeira versão do protótipo"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/palpitamente-site.git
git push -u origin main
```

## Passo 4 — Publicar no Vercel
1. Acesse https://vercel.com e crie uma conta (pode ser com GitHub).
2. Clique em **Add New → Project**.
3. Selecione o repositório `palpitamente-site` que você acabou de subir.
4. Em **Framework Preset**, deixe como **Other** (é site estático, não precisa de build).
5. Clique em **Deploy**. Em menos de um minuto seu site estará no ar em um endereço tipo `palpitamente-site.vercel.app`.

## Testando no dia da apresentação
1. Acesse o link do Vercel.
2. Vá em **Produtos** → clique em "Quero meu diário" (vai pedir login).
3. Crie uma conta de teste (ex: `demo@palpitamente.com`).
4. Volte em Produtos e clique em comprar de novo — agora libera o diário.
5. Escreva algumas páginas, arraste stickers, teste a aba de rabisco e veja a barra de progresso e a recompensa desbloqueando a cada 5 páginas.

## Se algo não funcionar
- Tela branca ou erro no console → confira se colou certo a URL e a chave do Supabase.
- "E-mail ou senha incorretos" ao logar logo após criar conta → provavelmente falta desativar a confirmação de e-mail (Passo 1.6).
- Diário não abre depois da compra → confira no Supabase, tabela `profiles`, se `has_diary` está `true` para o seu usuário.
