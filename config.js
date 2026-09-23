/* ============================================================================
   Configuração da loja.

   Enquanto estes dois campos estiverem vazios, a loja funciona do jeito
   antigo: produtos vindos do catalogo.json e senha de administração escrita
   no código (modo demonstração, sem segurança de verdade).

   Preenchendo os dois, a loja passa a usar o Supabase: produtos, catálogos e
   pedidos ficam no banco, e só quem tiver conta de administrador consegue
   alterar. Onde achar cada valor:

     Supabase > Project Settings > Data API
       supabaseUrl      -> "Project URL"
       supabaseAnonKey  -> "Project API keys" > anon / public

   A chave "anon" é pública de propósito: pode ficar aqui e aparecer no
   código da página. Quem protege os dados são as regras de acesso do banco
   (arquivo supabase/schema.sql), não o segredo da chave.
   NUNCA coloque aqui a chave "service_role" — essa ignora todas as regras.
   ============================================================================ */

window.LOJA_CONFIG = {
  supabaseUrl: 'https://blaypwcojloqgrucfrfj.supabase.co',
  supabaseAnonKey: 'sb_publishable_iFGXJcEYNCiVErmqtFP9Zw_Vi_cKf8r'
};
