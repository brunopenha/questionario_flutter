import 'package:meta/meta.dart'; // Para incluir parametros obrigatorios

abstract class ClienteHttp{
  Future<Map> requisita({
    @required String url,
    @required String metodo,
    Map corpo
  });
}