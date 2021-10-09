Feature: Acesso
Como um cliente
Quero poder acessar a minha conta e me manter com acesso
Para que eu possa ver e responder enquetes de forma rápida

Cenário: Credenciais Válidas
Dado que o cliente informou as credenciais válidas
Quando solicitar para fazer o acesso
Então o sistema deve enviar o usuário para a tela de pesquisas
E manter o usuário conectado

Cenário: Crendenciais Inválidas
Dado que o cliente informou credenciais inválidas
Quando solicitar para fazer o acesso
Então o sistema deve retornar uma mensagem de erro