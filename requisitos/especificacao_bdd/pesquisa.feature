Feature: Listar pesquisas
  Como um cliente
  Quero poder ver todas as pesquisas
  Para poder saber o resultado e poder dar a minha opnião

Scenario: Com Internet
  Dado que o cliente tem conexão com Internet
  Quando solicitar para ver as pesquisas
  Então o sistema deve exibir as pesquisas
  E armazenar os dados atualizados no cache

Scenario: Sem Internet
  Dado que o cliente não tem conexão com Internet
  Quando solicitar para ver as pesquisas
  Então o sistema deve exibir as pesquisas que foram gravadas no cache do ultimo acesso