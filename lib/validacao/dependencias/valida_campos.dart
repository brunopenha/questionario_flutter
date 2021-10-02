import '../../apresentacao/apresentacao.dart';

abstract class ValidaCampos {
  String get campo;

  ErroValidacao valida(String valor);
}
