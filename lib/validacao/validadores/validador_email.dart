import 'package:equatable/equatable.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidadorEmail extends Equatable implements ValidadorCampos {
  final String campo;

  @override
  List<Object> get props => [campo];

  ValidadorEmail(this.campo);

  @override
  ErroValidacao valida(String valor) {
    final regexEmailValido = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return valor?.isNotEmpty != true || regexEmailValido.hasMatch(valor)
        ? null
        : ErroValidacao.EMAIL_INVALIDO;
  }
}
