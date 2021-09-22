import 'package:equatable/equatable.dart';

import '../dependencias/dependencias.dart';

class ValidaCamposObrigatorios extends Equatable implements ValidaCampos {
  @override
  final String campo;

  @override
  List<Object> get props => [campo];

  ValidaCamposObrigatorios(this.campo);

  @override
  String valida(String valor) {
    return valor?.isNotEmpty == true ? null : 'Campo obrigatório';
  }
}
