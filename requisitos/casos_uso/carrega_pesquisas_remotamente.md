# Carrega Pesquisas Remotamente

> ## Caso de sucesso

1. ✅ Sistema faz uma requisição para a URL da API de pesquisas
2. Sistema valida o token de acesso para saber se o usuário tem permissão para ver esses dados (aqui iremos aplicar o
   padrão Decorator)
3. ✅ Sistema valida os dados recebidos da API
4. ✅ Sistema entrega os dados das pesquisas

> ## Exceção - URL inválida

1. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Acesso Negado

1. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Resposta inválida

1. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor

1. Sistema retorna uma mensagem de erro inesperado
