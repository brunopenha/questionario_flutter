import 'package:flutter_test/flutter_test.dart';
import 'package:questionario/validacao/dependencias/dependencias.dart';

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

void main() {
  ValidaEmail sut;

  setUp(() {
    sut = ValidaEmail('qualquer_campo');
  });

  test('Deveria retornar null se o email estiver vazio', () {
    expect(sut.valida(''), null);
  });

  test('Deveria retornar null se o email estiver vazio', () {
    expect(sut.valida(null), null);
  });

  test('Deveria retornar null se o email for valido', () {
    expect(sut.valida('dev@bruno.penha.nom.br'), null);
  });

  test('Deveria retornar erro se o email for invalido', () {
    expect(sut.valida('bruno.penha.nom.br'), 'Email inválido');
  });
}
