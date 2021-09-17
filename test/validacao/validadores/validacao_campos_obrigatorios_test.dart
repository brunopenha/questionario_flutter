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
    return valor?.isNotEmpty == true ? null : 'Campo obrigatório';
  }
}

void main() {
  ValidaCamposObrigatorios sut;

  setUp(() {
    sut = ValidaCamposObrigatorios('qualquer_campo');
  });

  test('Deveria retornar null se o valor não estiver vazio', () {
    expect(sut.valida('qualquer_campo'), null);
  });

  test('Deveria retornar erro se o valor estiver vazio', () {
    expect(sut.valida(''), 'Campo obrigatório');
  });

  test('Deveria retornar erro se o valor estiver nulo', () {
    expect(sut.valida(null), 'Campo obrigatório');
  });
}
