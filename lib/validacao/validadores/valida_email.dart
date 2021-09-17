import '../dependencias/dependencias.dart';

class ValidaEmail implements ValidaCampos {
  final String campo;

  ValidaEmail(this.campo);

  @override
  String valida(String valor) {
    final regexEmailValido = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return valor?.isNotEmpty != true || regexEmailValido.hasMatch(valor) ? null : 'Email inválido';
  }
}
