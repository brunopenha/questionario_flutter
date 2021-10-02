import 'package:meta/meta.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:questionario/dominios/erros/erros.dart';

class AdicionaContaRemota {
  final ClienteHttp clienteHttp;
  final String url;

  AdicionaContaRemota({@required this.clienteHttp, @required this.url});

  Future<void> adiciona(ParametrosAdicionaContaRemota parametro) async {
    final body = ParametrosAdicionaContaRemota.aPartirDoDominio(parametro).criaJson();
    try {
      await clienteHttp.requisita(url: url, metodo: 'post', corpo: body);
    } on ErrosHttp {
      throw ErrosDominio.inesperado;
    }
  }
}

class ParametrosAdicionaContaRemota {
  final String nome;
  final String email;
  final String senha;
  final String confirmaSenha;

  ParametrosAdicionaContaRemota(
      {@required this.nome, @required this.email, @required this.senha, @required this.confirmaSenha});

  factory ParametrosAdicionaContaRemota.aPartirDoDominio(ParametrosAdicionaContaRemota entidade) =>
      ParametrosAdicionaContaRemota(
          nome: entidade.nome,
          email: entidade.email,
          senha: entidade.senha,
          confirmaSenha: entidade.confirmaSenha);

  // acesso a API para verificar os parametros:
  // https://fordevs.herokuapp.com/api-docs/#/Login/post_signup
  Map criaJson() => {'name': nome, 'email': email, 'password': senha, 'passwordConfirmation': confirmaSenha};
}
