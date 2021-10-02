import 'package:equatable/equatable.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidaCamposObrigatorios extends Equatable implements ValidaCampos {
  @override
  final String campo;

  @override
  List<Object> get props => [campo];

  ValidaCamposObrigatorios(this.campo);

  @override
  ErroValidacao valida(String valor) {
    return valor?.isNotEmpty == true ? null : ErroValidacao.CAMPO_OBRIGATORIO;
  }
}
