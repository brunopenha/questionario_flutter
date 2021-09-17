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
}
