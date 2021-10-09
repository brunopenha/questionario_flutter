import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidadorComparaCampos extends Equatable implements ValidadorCampos {
  final String campo;
  final String campoParaComparar;

  @override
  List<Object> get props => [campo, campoParaComparar];

  ValidadorComparaCampos({@required this.campo, @required this.campoParaComparar});

  @override
  ErroValidacao valida(Map entrada) => entrada[campo] != null &&
          entrada[campoParaComparar] != null &&
          entrada[campoParaComparar] != entrada[campo]
      ? ErroValidacao.DADO_INVALIDO
      : null;
}
