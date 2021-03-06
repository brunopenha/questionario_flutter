import 'package:meta/meta.dart';


import '../../dominios/casosuso/casosuso.dart';
import '../../dominios/erros/erros.dart';
import '../http/http.dart'; // Para incluir parametros obrigatorios

class AutenticacaoRemota {
  final ClienteHttp clienteHttp;
  final String url;

  AutenticacaoRemota({
    @required this.clienteHttp,
    @required this.url
  });

  Future<void> autoriza(ParametrosAutenticacao parametro) async {
    final body = ParametrosAutenticacaoRemota.aPartirDoDominio(parametro).criaJson();
    try{
      await clienteHttp.requisita(url: url, metodo:'post', corpo: body);
    } on ErrosHttp catch (erro) {
       
        throw erro == ErrosHttp.unauthorized ?
           ErrosDominio.credenciaisInvalidas :
           ErrosDominio.inesperado;
    }
    
  }
}

class ParametrosAutenticacaoRemota{
  final String email;
  final String senha;

  ParametrosAutenticacaoRemota({
    @required this.email,
    @required this.senha
  });

  factory ParametrosAutenticacaoRemota.aPartirDoDominio(ParametrosAutenticacao entidade) =>
    ParametrosAutenticacaoRemota(email: entidade.email, senha: entidade.senha);

  Map criaJson() => {'email':email, 'senha':senha};
}
