# Comércio Do Luiz 💨

Loja virtual com estoque, cadastro de clientes, carrinho, checkout e painel
de administração. Tudo roda no navegador, sem servidor.

## Arquivos

| Arquivo | Para que serve |
|---|---|
| `index.html` | A loja. É o que o GitHub Pages publica. |
| `catalogo.json` | Os produtos que aparecem no site publicado. |
| `loja-sincronizada.html` | Versão que roda dentro da Claude e guarda tudo num banco compartilhado. |

## Endereço do site

Com o GitHub Pages ligado (Settings → Pages → Deploy from a branch), a loja
fica em:

https://jovemaprendiz-ai.github.io/teste/

## Como mudar os produtos do site

1. Abra a loja e entre em **⚙️ Administração** (senha `admin123`).
2. Cadastre, edite ou exclua os produtos.
3. Clique em **📥 Baixar catalogo.json**.
4. No GitHub, substitua o `catalogo.json` pelo arquivo baixado.

Em poucos minutos o site mostra o catálogo novo para todo mundo.

## O que fica salvo onde

- **Produtos**: no `catalogo.json` do site (iguais para todos os visitantes).
- **Contas e pedidos**: na memória do navegador de cada pessoa.
- **Pedidos até o lojista**: pelo WhatsApp, no fim da compra.

Para contas e pedidos num painel único é preciso um servidor com banco de
dados — nenhum site estático dá conta disso sozinho.

## Senha da administração

`admin123`, definida em `SENHA_ADMIN`, dentro do `index.html`. Ela fica no
código, visível para quem abrir o arquivo: serve para organizar o dia a dia,
não para proteger dinheiro ou dados de verdade.

## Banco de dados (Supabase)

Sem banco, a senha da administração fica escrita no `index.html` e qualquer
visitante consegue lê-la. Com banco, quem confere a senha é o servidor, e as
regras de acesso ficam no próprio banco — ninguém as contorna pelo navegador.

**Quem pode o quê, depois de configurado:**

| | Visitante | Administrador |
|---|---|---|
| Ver produtos e catálogos | ✅ | ✅ |
| Criar um pedido | ✅ | ✅ |
| Ler os pedidos | ❌ | ✅ |
| Alterar produtos e catálogos | ❌ | ✅ |
| Enviar fotos | ❌ | ✅ |

### Como ligar

1. Crie uma conta em https://supabase.com e um projeto novo (guarde a senha
   do banco que ele pedir).
2. Menu **SQL Editor** → **New query** → cole todo o `supabase/schema.sql` →
   **Run**.
3. Menu **Authentication → Users → Add user**: informe seu e-mail e uma senha
   forte e marque **Auto Confirm User**.
4. Menu **Authentication → Sign In / Providers**: desligue **Allow new users
   to sign up**, para ninguém criar conta sozinho.
5. Volte ao **SQL Editor**, cole o `supabase/promover-admin.sql`, troque o
   e-mail pelo seu e rode. Deve aparecer uma linha com o seu e-mail.
6. Menu **Project Settings → Data API**: copie **Project URL** e a chave
   **anon / public**.
7. Preencha esses dois valores em `config.js` e envie para o GitHub.

A chave `anon` é pública de propósito e pode aparecer no código da página.
A que nunca pode sair do painel do Supabase é a `service_role`, porque ela
ignora todas as regras de acesso.

### O que continua no navegador

As contas de cliente e o carrinho seguem no navegador de cada pessoa. O que
passou para o servidor foi o essencial: produtos, catálogos e pedidos.
