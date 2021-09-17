import 'package:flutter_test/flutter_test.dart';
import 'package:questionario/validacao/dependencias/dependencias.dart';

class ValidaEmail implements ValidaCampos {
  final String campo;

  ValidaEmail(this.campo);

  @override
  String valida(String valor) {
    return null;
  }
}

void main() {
  test('Deveria retornar null se o email estiver vazio', () {
    final sut = ValidaEmail('qualquer_campo');

    expect(sut.valida(''), null);
  });

  test('Deveria retornar null se o email estiver vazio', () {
    final sut = ValidaEmail('qualquer_campo');

    expect(sut.valida(null), null);
  });
}
