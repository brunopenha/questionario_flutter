# Carrega Pesquisas Localmente

> ## Caso de sucesso
1. Sistema solicita os dados das pesquisas do Cache
2. Sistema valida os dados recebidos do Cache
3. Sistema entrega os dados das pesquisas

> ## Exceção - Cache vazio
1. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Dados inválidos no cache
1. Sistema retorna uma mensagem de erro inesperado
2. Sistema limpa os dados do cache