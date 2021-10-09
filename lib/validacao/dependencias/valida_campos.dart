import '../../apresentacao/apresentacao.dart';

abstract class ValidadorCampos {
  String get campo;

  ErroValidacao valida(String valor);
}
