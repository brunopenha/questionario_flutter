#HTTP

> ## Sucesso

1. `:heavy_check_mark:` Request com verbo http válido (POST)
2. `:heavy_check_mark:` Passar nos headers o `Content-type: application/json`
3. `:heavy_check_mark:` Chamar o request com o _body_ correto.
4. `:heavy_check_mark:` `200 - OK` e resposta com dados
5. `:heavy_check_mark:` `204 - No Content` e resposta sem dados

> ## Erros

1. `:heavy_check_mark:` 400 - Bad Request
2. 401 - Unauthorized
3. 403 - Forbidden
4. 404 - Not Found
5. `:heavy_check_mark:` 500 - Internal Server Error

> ## Exceção - Status code diferente dos citados acima
1. `:heavy_check_mark:` Internal Server Error

> ## Exceção - A requisição HTTP deu alguma exceção
1. Internal Server Error

> ## Exceção - Verbo http inválido
1. Internal Server Error