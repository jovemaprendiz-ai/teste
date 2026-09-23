-- ============================================================================
--  Comércio Do Luiz — estrutura do banco de dados (Supabase / PostgreSQL)
--
--  Cole este arquivo inteiro no SQL Editor do Supabase e clique em RUN.
--  Pode rodar mais de uma vez: nada é apagado nem duplicado.
--
--  A regra que dá segurança à loja está no fim do arquivo:
--    - qualquer visitante LÊ produtos e catálogos, e CRIA pedidos;
--    - só quem estiver na tabela "admins" ALTERA produtos e catálogos
--      ou ENXERGA os pedidos.
--  Isso é aplicado pelo banco, não pelo navegador — então ninguém
--  contorna abrindo o código da página.
-- ============================================================================

-- ----------------------------------------------------------------- tabelas --

create table if not exists public.catalogos (
  id        bigint primary key,
  nome      text not null,
  criado_em timestamptz not null default now()
);

create table if not exists public.produtos (
  id            bigint primary key,
  nome          text not null,
  descricao     text not null default '',
  preco         numeric(12,2) not null default 0,
  estoque       integer not null default 0,
  emoji         text not null default '📦',
  imagem_url    text not null default '',
  catalogos     bigint[] not null default '{}',
  atualizado_em timestamptz not null default now()
);

create table if not exists public.pedidos (
  id               bigint primary key,
  numero           text not null,
  criado_em        timestamptz not null default now(),
  cliente_nome     text not null,
  cliente_email    text not null,
  cliente_cep      text not null default '',
  tipo_recebimento text not null default 'entrega',
  metodo_pagamento text not null default 'pix',
  itens            jsonb not null default '[]'::jsonb,
  total            numeric(12,2) not null default 0,
  status           text not null default 'Pendente'
);

-- Quem pode administrar a loja. Entrar aqui é só pelo SQL Editor,
-- então ninguém se promove a administrador sozinho.
create table if not exists public.admins (
  user_id   uuid primary key references auth.users(id) on delete cascade,
  email     text,
  criado_em timestamptz not null default now()
);

create index if not exists produtos_catalogos_idx on public.produtos using gin (catalogos);
create index if not exists pedidos_criado_em_idx  on public.pedidos (criado_em desc);

-- ------------------------------------------------------ quem é admin mesmo --

create or replace function public.e_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

-- ------------------------------------------------- regras de acesso (RLS) --

alter table public.produtos  enable row level security;
alter table public.catalogos enable row level security;
alter table public.pedidos   enable row level security;
alter table public.admins    enable row level security;

drop policy if exists produtos_leitura_publica on public.produtos;
create policy produtos_leitura_publica on public.produtos
  for select using (true);

drop policy if exists produtos_escrita_admin on public.produtos;
create policy produtos_escrita_admin on public.produtos
  for all using (public.e_admin()) with check (public.e_admin());

drop policy if exists catalogos_leitura_publica on public.catalogos;
create policy catalogos_leitura_publica on public.catalogos
  for select using (true);

drop policy if exists catalogos_escrita_admin on public.catalogos;
create policy catalogos_escrita_admin on public.catalogos
  for all using (public.e_admin()) with check (public.e_admin());

-- Pedido: o cliente CRIA o dele, mas não consegue LER os dos outros.
drop policy if exists pedidos_criacao_livre on public.pedidos;
create policy pedidos_criacao_livre on public.pedidos
  for insert with check (true);

drop policy if exists pedidos_admin_total on public.pedidos;
create policy pedidos_admin_total on public.pedidos
  for all using (public.e_admin()) with check (public.e_admin());

drop policy if exists admins_leitura_propria on public.admins;
create policy admins_leitura_propria on public.admins
  for select using (user_id = auth.uid());

-- ---------------------------------------------------- fotos dos produtos --

insert into storage.buckets (id, name, public)
values ('fotos', 'fotos', true)
on conflict (id) do nothing;

drop policy if exists fotos_leitura_publica on storage.objects;
create policy fotos_leitura_publica on storage.objects
  for select using (bucket_id = 'fotos');

drop policy if exists fotos_envio_admin on storage.objects;
create policy fotos_envio_admin on storage.objects
  for insert with check (bucket_id = 'fotos' and public.e_admin());

drop policy if exists fotos_troca_admin on storage.objects;
create policy fotos_troca_admin on storage.objects
  for update using (bucket_id = 'fotos' and public.e_admin());

drop policy if exists fotos_apagar_admin on storage.objects;
create policy fotos_apagar_admin on storage.objects
  for delete using (bucket_id = 'fotos' and public.e_admin());
