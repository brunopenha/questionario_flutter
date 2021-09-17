import 'package:flutter_test/flutter_test.dart';
import 'package:questionario/validacao/validadores/validadores.dart';

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
