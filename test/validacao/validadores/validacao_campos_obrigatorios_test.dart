import 'package:flutter_test/flutter_test.dart';

abstract class ValidaCampos {
  String get campo;

  String valida(String valor);
}

class ValidaCamposObrigatorios implements ValidaCampos {
  @override
  final String campo;

  ValidaCamposObrigatorios(this.campo);

  @override
  String valida(String valor) {
    return null;
  }
}

void main() {
  test('Deveria retornar null se o valor não estiver vazio', () {
    final sut = ValidaCamposObrigatorios('qualquer_campo');

    final erro = sut.valida('qualquer_campo');

    expect(erro, null);
  });
}
