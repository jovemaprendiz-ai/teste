-- ============================================================================
--  Transforma um usuário já criado em administrador da loja.
--
--  Antes de rodar: crie o usuário em Authentication > Users > Add user,
--  com e-mail e senha, e marque "Auto Confirm User".
--
--  Depois troque o e-mail abaixo pelo seu e clique em RUN.
-- ============================================================================

insert into public.admins (user_id, email)
select id, email
  from auth.users
 where email = 'TROQUE-PELO-SEU@EMAIL.COM'
on conflict (user_id) do nothing;

-- Confira: esta consulta deve devolver uma linha com o seu e-mail.
select * from public.admins;
