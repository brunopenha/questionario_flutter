## Apresentador de Inscricao

> ## Regras

1. ✅ Chamar Validador ao alterar o email
2. ✅ Notificar o emailComErroStream com o mesmo erro do Validador, caso retorne erro
3. ✅ Notificar o emailComErroStream com null, caso o Validador não retorne erro
4. ✅ Não notificar o emailComErroStream se o valor for igual ao do ultimo
5. ✅ Notificar o camposSaoValidosStream após alterar o email
6. ✅ Chamar o validador ao alterar a senha
7. ✅ Notificar o senhaComErroStream com o mesmo erro do Validador, caso retorne erro
8. ✅ Notificar o senhaComErroStream com null, caso o validador não retorne erro
9. ✅ Não notificar o senhaComErroStream  se o valor fo igual ao último
10. Notificar o camposSaoValidosStream após alterar a senha
11. ✅ Chamar o Validador ao alterar o nome
12. ✅ Notificar nomeComErroStream com o mesmo erro do Validador, caso retorne um erro
13. ✅ Notificar o nomeComErroStream com null, caso o Validador não retorne erro
14. ✅ Não notificar o nomeComErroStream se o valor for igual ao último
15. ✅ Notificar o camposSaoValidosStream após alterar o nome
16. ✅ Chamar o Validador ao alterar a confirmação da senha
17. ✅ Notificar o confirmacaoSenhaComErroStream com o mesmo erro do Validador, caso retorne um erro
18. ✅ Notificar o confirmacaoSenhaComErroStream com null, caso o Validador não retorne erro
19. ✅ Não notificar o confirmarcaoSenhaComErro se o valor for igual ao ultimo
20. ✅ Notificar o camposSaoValidosStream após alterar a confirmação da senha
21. ✅ Para o formulário estar válido, todos os Streams de erro precisam estar null e todos os campos obrigatórios não 
22. ✅ Não notificar o camposSaoValidos se o valor for igual ao ultimo
23. ✅ Chamar o AdicionaConta com valores corretos
24. ✅ Notificar o paginaEstaCarregandoStream como true antes de chamar o AdicionaConta
25. ✅ Notificar o paginaEstaCarregandoStream como false no fim de AdicionaConta
26. Notificar o falhaInscricaoStream caso o AdicionaConta retorne um erro
27. VFechar todos os Streams no dispose
28. ✅ Gravar a Conta no cache em caso de sucesso
29. ✅ Notificar o falhaInscricaoStream caso o SalvaContaAtual retorne erro
30. Levar o usuário para a tela de Pesquisas em caso de sucesso
31. Levar o usuário para a tela de Acesso ao pressionar o botão de voltar para o acesso