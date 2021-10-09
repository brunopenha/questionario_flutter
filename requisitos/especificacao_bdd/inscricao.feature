Feature: Criar conta
  Como um cliente
  Quero poder criar uma conta e me manter conectado
  Para que eu possa ver e responder pesquisas de forma rapida

Scenario: Dados válidos
  Dado que o cliente informou os dados validos
  Quando solicitar para criar a conta
  Então o sistema deve enviar o usuário para a tela de pesquisas
  E manter o usuário conectado

Scenario: Dados inválidos
  Dado que o cliente informou os dados inválidos
  Quando solicitar para criar a conta
  Então o sistema deve retornar uma mensagem de erro