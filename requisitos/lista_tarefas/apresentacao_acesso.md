# Apresentação Acesso

> ## Regras:

1.  ✅ Chamar o `Validacao` ao alterar o email
2.  ✅ Notificar o `emailComErroStream` com o mesmo erro do `Validador`, caso retorne erro
3.  ✅ Notificar o `emailComErroStream` com `null`, caso o `Validador` não retorne erro
4.  ✅ Não notificar o `emailComErroStream` se o valor for igual ao do último
5.  ✅ Notificar o `camposSaoValidosStream` após alterar o email
6.  ✅ Chamar o `Validador` ao alterar a senha
7.  ✅ Notificar o `senhaComErroStream` com o mesmo erro do `Validador`, caso retorne erro
8.  ✅ Notificar o `senhaComErroStream` com `null`, caso o `Validador` não retorne erro
9.  ✅ Não notificar o `senhaComErroStream`  se o valor for igual ao do último
10. ✅ Notificar o `camposSaoValidosStream` após alterar a senha
11. ✅ Para o formulário ser válido, todos os `Streams` de erro precisam estar `null` e todos os campos obrigatórios não podem estar vazios.
12. ✅ Não notificar o `camposSaoValidosStream` se o valor for igual ao ultimo
13. ✅ Chamar o `Autenticador` com o email e senha válidos
14. ✅ Notificar o `paginaEstaCarregandoStream` com `true` antes de chamar o `Autenticador`
15. ✅ Notificar o `paginaEstaCarregandoStream` com `false` no fim do `Autenticador`
16. ✅ Notificar o `falhaAcessoStream` caso o `Autenticador` retorne um `ErroDominio`
17. Fechar todos os `Streams` no `dispose` (`liberarMemória`)
18. ⛔ Gravar a `Conta` no cache em caso de sucesso
19. ⛔ Levar o usuário para a tela de Questionários em caso de sucesso.

