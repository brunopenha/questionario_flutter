import '../../apresentacao/apresentacao.dart';

abstract class ValidadorCampos {
  String get campo;

  ErroValidacao valida(Map entrada); // Aqui terei todos os dados do formulario
}
