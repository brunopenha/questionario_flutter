import 'package:flutter_test/flutter_test.dart';
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/validacao/validadores/validadores.dart';

void main() {
  ValidadorCamposObrigatorios sut;

  setUp(() {
    sut = ValidadorCamposObrigatorios('qualquer_campo');
  });

  test('Deveria retornar null se o valor não estiver vazio', () {
    expect(sut.valida({'qualquer_campo': 'qualquer_valor'}), null);
  });

  test('Deveria retornar erro se o valor estiver vazio', () {
    expect(sut.valida({'qualquer_campo': ''}), ErroValidacao.CAMPO_OBRIGATORIO);
  });

  test('Deveria retornar erro se o valor estiver nulo', () {
    expect(sut.valida({'qualquer_campo': null}), ErroValidacao.CAMPO_OBRIGATORIO);
  });
}
