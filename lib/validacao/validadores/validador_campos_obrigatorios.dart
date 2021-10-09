import 'package:equatable/equatable.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidadorCamposObrigatorios extends Equatable implements ValidadorCampos {
  @override
  final String campo;

  @override
  List<Object> get props => [campo];

  ValidadorCamposObrigatorios(this.campo);

  @override
  ErroValidacao valida(String valor) {
    return valor?.isNotEmpty == true ? null : ErroValidacao.CAMPO_OBRIGATORIO;
  }
}
