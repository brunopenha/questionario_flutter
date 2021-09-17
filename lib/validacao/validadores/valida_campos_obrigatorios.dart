import '../dependencias/dependencias.dart';

class ValidaCamposObrigatorios implements ValidaCampos {
  @override
  final String campo;

  ValidaCamposObrigatorios(this.campo);

  @override
  String valida(String valor) {
    return valor?.isNotEmpty == true ? null : 'Campo obrigatório';
  }
}
