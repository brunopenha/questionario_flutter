import 'package:meta/meta.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidadorComparaCampos implements ValidadorCampos {
  final String campo;
  final String valorParaComparar;

  ValidadorComparaCampos({@required this.campo, @required this.valorParaComparar});

  @override
  ErroValidacao valida(String valorASerComparado) {
    return ErroValidacao.DADO_INVALIDO;
  }
}
