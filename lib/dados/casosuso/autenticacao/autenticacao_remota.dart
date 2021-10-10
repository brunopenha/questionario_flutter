import 'package:meta/meta.dart';

import '../../../dominios/casosuso/casosuso.dart';
import '../../../dominios/entidades/entidades.dart';
import '../../../dominios/erros/erros.dart';
import '../../http/http.dart'; // Para incluir parametros obrigatorios
import '../../modelos/modelos.dart';

class AutenticacaoRemota implements Autenticador {
  final ClienteHttp<Map> clienteHttp;
  final String url;

  AutenticacaoRemota({@required this.clienteHttp, @required this.url});

  Future<Conta> autoriza(ParametrosAutenticador parametro) async {
    final body =
        ParametrosAutenticacaoRemota.aPartirDoDominio(parametro).criaJson();
    try {
      final responseHttp = await clienteHttp.requisita(
          caminho: url, metodo: 'post', corpo: body);
      return ModeloContaRemota.doJson(responseHttp).paraEntidade();
    } on ErrosHttp catch (erro) {
      throw erro == ErrosHttp.unauthorized
          ? ErrosDominio.credenciaisInvalidas
          : ErrosDominio.inesperado;
    }
  }
}

class ParametrosAutenticacaoRemota {
  final String email;
  final String senha;

  ParametrosAutenticacaoRemota({@required this.email, @required this.senha});

  factory ParametrosAutenticacaoRemota.aPartirDoDominio(
          ParametrosAutenticador entidade) =>
      ParametrosAutenticacaoRemota(
          email: entidade.email, senha: entidade.senha);

  // acesso a API para verificar os parametros:
  // https://fordevs.herokuapp.com/api-docs/#/Login/post_login
  Map criaJson() => {'email': email, 'password': senha};
}
