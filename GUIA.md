# Guia do site Palpitamente

## Antes de tudo: use o painel

Episódios, indicações, preço, textos e links das redes agora se editam
pelo **painel do site**, em `palpitamente.vercel.app/admin.html`.

Entre com uma conta da equipe e o botão rosa **Painel** aparece no topo.
O que você salvar lá vale na hora, sem CMD e sem deploy.

Este guia serve para o que ainda vive nos arquivos: fotos, stickers,
recompensas e textos fixos das páginas.

---

Onde mexer em cada coisa, sem precisar pedir ajuda.

Regra geral: **arquivos `.js` dentro de `assets/` guardam conteúdo**
(episódios, indicações, stickers). Os `.html` guardam textos fixos e
layout. Você abre qualquer um deles no Bloco de Notas ou VS Code.

Depois de editar, sempre:

```
git add -A
git commit -m "o que voce mudou"
git push origin main
```

---

## 1. Episódios do podcast

**Agora é pelo painel:** aba **Episódios**.

Criar, editar, excluir, marcar como publicado ou rascunho. No campo do
YouTube você pode colar a URL inteira que o painel extrai o código.

O arquivo `assets/episodios.js` continua no projeto, mas só como rede de
segurança: se o banco não responder, o site cai nele. Não edite mais por lá.

<details>
<summary>Formato antigo, caso precise</summary>

**Arquivo:** `assets/episodios.js`

Cada episódio é um bloco assim:

```js
{
  numero: '01',
  titulo: 'Nome do episódio',
  descricao: 'Uma linha sobre o que rolou nesse episódio.',
  duracao: '30 Min',
  youtube: 'VUO2XyGrVpw',        // só o código, não a URL inteira
  spotify: '',                    // cole o link completo quando tiver
  soundcloud: '',
  publicado: true                 // false = card de "lançamento em breve"
}
```

**Como pegar o código do YouTube:** na URL
`https://www.youtube.com/watch?v=VUO2XyGrVpw`, o código é `VUO2XyGrVpw`.
Em link curto `https://youtu.be/VUO2XyGrVpw`, é a parte depois da barra.

**Para publicar um episódio novo:** troque `publicado: false` por `true`
no próximo da lista e preencha os campos.

A capa vem sozinha da miniatura do YouTube. Você não precisa subir imagem.

A home mostra os três primeiros. A página `episodios.html` mostra todos.
O botão "DÁ O PLAY" do carrossel aponta sozinho para o episódio mais recente.

</details>

---

## 2. Indicações de livros, filmes e séries

**Agora é pelo painel:** aba **Indicações**.

Tem upload de capa direto do computador e o campo de gênero muda sozinho
conforme o tipo: 36 opções para livro, 41 para filme e série.

<details>
<summary>Formato antigo, caso precise</summary>

**Arquivo:** `assets/indicacoes.js`

```js
{
  tipo: 'livro',                  // 'livro', 'filme' ou 'serie'
  titulo: 'Tudo é Rio',
  autor: 'Carla Madeira',         // autoria, direção ou criação
  genero: 'Ficção literária',     // escolha da lista de gêneros do arquivo
  capa: 'tudo-e-rio.jpg',         // arquivo dentro de assets/capas/
  nota: '',                       // linha de vocês sobre a indicação
  sinopse: ''                     // texto que aparece ao clicar no card
}
```

**Capas:** coloque a imagem em `assets/capas/`, de preferência 400x600 px
em JPG. Escreva só o nome do arquivo no campo `capa`. Se deixar vazio,
entra um símbolo de livro no lugar.

**Gêneros:** as listas completas estão no topo do arquivo, em
`GENEROS_LIVRO` (36 opções) e `GENEROS_TELA` (41 opções). Escreva
exatamente igual, com acento e maiúscula, senão vira dois filtros
diferentes para o mesmo gênero.

O filtro da página se monta sozinho e só mostra gêneros que têm obra.

</details>

---

## 3. Preço do Diário Digital

**Agora é pelo painel:** aba **Textos e preços**, grupo "Diário Digital".

<details>
<summary>Onde fica no arquivo, se precisar</summary>

**Arquivo:** `produtos.html`

Procure por `R$ 0,00`. Está em dois lugares:

- O valor grande no cartão
- A lista de itens abaixo dele

Para mudar o texto dos benefícios, procure pelas linhas dentro de
`<ul>` no mesmo cartão.

Os três blocos numerados (01, 02, 03) no fim da página também estão
nesse arquivo, procure por `beneficio-num`.

</details>

---

## 4. Textos das páginas

| O que | Arquivo | Como achar |
|---|---|---|
| Título e texto do carrossel | `index.html` | procure `podcast-titulo` e `diario-lead` |
| História do Palpitamente | `sobre.html` | procure `sobre-texto` |
| Lista "O que nos guia" | `sobre.html` | procure `class="guia"` |
| Nomes das integrantes | `sobre.html` | procure `class="integrante"` |
| Diretrizes da comunidade | `diario.html` | procure `class="diretrizes"` |

---

## 5. Fotos das integrantes

**Pasta:** `assets/partes/`

Os arquivos têm nome fixo. Para trocar uma foto, substitua o arquivo
mantendo o mesmo nome:

- `integrante-camila.jpg`
- `integrante-laura.jpg`
- `integrante-livia.jpg`
- `integrante-mara.jpg`
- `integrante-vitoria.jpg`
- `podcast-foto.jpg` (a foto do grupo no carrossel)

Formato: quadrado para os retratos, 560x560 px. A do grupo é larga,
1548x710 px.

---

## 6. Links das redes sociais

**Agora é pelo painel:** aba **Textos e preços**, grupo "Redes".

<details>
<summary>Onde ficam nos arquivos</summary>

Estão em **todas** as páginas `.html`, no topo e no rodapé.

A forma mais segura de trocar é usar "Substituir tudo" no editor,
procurando pelo endereço antigo e trocando pelo novo. Faça isso em
cada arquivo `.html`.

Endereços atuais:

```
https://www.instagram.com/palpitamente
https://www.youtube.com/@PalpitamentePodcast
https://www.tiktok.com/@palpitamente
https://open.spotify.com/show/4Nqvxvfy1jntHZeC2VltgI
https://on.soundcloud.com/6PZZUpQEnQgUUDeTgH
```

Telefone e e-mail também estão no rodapé de cada página, procure por
`95789-5463` e `contato@palpitamente.com`.

</details>

---

## 7. Stickers do diário

Existem três origens.

**a) Stickers de conquista** (emojis, liberados a cada X páginas)
Arquivo: `diario.html`, procure por `const PREMIOS`.

**b) Pacotes da equipe** (imagens que vocês desenham)
Arquivo: `assets/stickers.js`

1. Coloque os PNG em `assets/stickers/`, com fundo transparente,
   400x400 px, até 150 KB cada
2. Registre o pacote:

```js
{
  nome: 'Palpitamente',
  liberadoEm: 0,               // 0 = todas veem desde o começo
  arquivos: ['coracao.png', 'xicara.png']
}
```

**c) Stickers da usuária**
Ela sobe pelo próprio painel, na aba Stickers do diário. Ficam salvos
na conta dela, limite de 60 por pessoa. Vocês não precisam fazer nada.

---

## 8. Recompensas do diário

**Arquivo:** `diario.html`, procure por `const PREMIOS`.

```js
{ em:5, icone:'🌱', nome:'Primeiros passos',
  desc:'Pacote de stickers de plantinhas.',
  stickers:['🌱','🌿','🍀','🌻'] }
```

`em` é a quantidade de páginas para liberar. São 15 marcos, de 5 a 365.

---

## 9. Banco de dados

Os arquivos em `supabase/` já foram executados. Você só volta neles
se precisar recriar o projeto do zero. Nesse caso, rode na ordem:

1. `schema.sql`
2. `schema-v2.sql`
3. `schema-v3.sql`
4. `schema-v4.sql`
5. `schema-v5.sql`
6. `schema-v6.sql`
7. `schema-v7.sql`

---

## 11. Dar acesso ao painel

**Pelo painel:** aba **Equipe**, digite o e-mail e clique em "Dar acesso".
A pessoa precisa já ter conta no site.

**Pela primeira vez**, quando ainda não há nenhuma administradora, é pelo
SQL Editor do Supabase:

```sql
update public.profiles set is_admin = true
 where id = (select id from auth.users where lower(email) = 'palpitamente@gmail.com');
```

---

## 10. Antes de subir qualquer coisa

Abra o `index.html` com dois cliques e confira no navegador. Ele abre
em `file://` e mostra o visual sem precisar de servidor. O login não
funciona nesse modo, mas para conferir texto e imagem serve.

Se algo quebrar depois do push, dá para voltar atrás:

```
git log --oneline          # veja os últimos commits
git revert <codigo>        # desfaz aquele commit
git push origin main
```
