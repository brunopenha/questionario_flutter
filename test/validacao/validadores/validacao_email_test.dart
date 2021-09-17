import 'package:flutter_test/flutter_test.dart';
import 'package:questionario/validacao/validadores/validadores.dart';

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
