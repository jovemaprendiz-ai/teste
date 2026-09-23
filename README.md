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
