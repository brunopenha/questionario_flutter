import 'package:meta/meta.dart'; // Para incluir parametros obrigatorios

/// Quem utilizar essa classe, deveria dizer qual é o tipo de resposta
abstract class ClienteHttp<ResponseType> {
  Future<ResponseType> requisita(
      {@required String caminho, @required String metodo, Map corpo});
}
