import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidadorTamanhoMinimo extends Equatable implements ValidadorCampos {
  final String campo;
  final int tamanhoCampo;

  @override
  List<Object> get props => [campo, tamanhoCampo];

  ValidadorTamanhoMinimo({@required this.campo, @required this.tamanhoCampo});

  @override
  ErroValidacao valida(Map entrada) =>
      entrada[campo] != null && entrada[campo].length >= tamanhoCampo ? null : ErroValidacao.DADO_INVALIDO;
}
