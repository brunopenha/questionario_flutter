import 'package:meta/meta.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidadorComparaCampos implements ValidadorCampos {
  final String campo;
  final String campoParaComparar;

  ValidadorComparaCampos({@required this.campo, @required this.campoParaComparar});

  @override
  ErroValidacao valida(Map entrada) {
    return entrada[campoParaComparar] == entrada[campo] ? null : ErroValidacao.DADO_INVALIDO;
  }
}
