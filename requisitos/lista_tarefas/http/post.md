#HTTP Get

> ## Sucesso

1. Request com verbo http válido (Get)
2. Passar nos headers o `Content-type: application/json`
3. Chamar o request com o _body_ correto.
4. `200 - OK` e resposta com dados
5. `204 - No Content` e resposta sem dados

> ## Erros

1. 400 - Bad Request
2. 401 - Unauthorized
3. 403 - Forbidden
4. 404 - Not Found
5. 500 - Internal Server Error

> ## Exceção - Status code diferente dos citados acima
1. Internal Server Error

> ## Exceção - A requisição HTTP deu alguma exceção
1. Internal Server Error

> ## Exceção - Verbo http inválido
1. Internal Server Error