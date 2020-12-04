import 'package:meta/meta.dart';

import '../../dominios/casosuso/casosuso.dart';
import '../http/http.dart'; // Para incluir parametros obrigatorios

class AutenticacaoRemota {
  final ClienteHttp clienteHttp;
  final String url;

  AutenticacaoRemota({
    @required this.clienteHttp,
    @required this.url
  });

  Future<void> autoriza(ParametrosAutenticacao parametro) async {
    await clienteHttp.requisita(url: url, metodo:'post', body: parametro.criaJson());
  }
}
