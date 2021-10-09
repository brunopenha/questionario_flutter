import 'package:flutter_test/flutter_test.dart';
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/validacao/validadores/validadores.dart';

void main() {
  ValidadorEmail sut;

  setUp(() {
    sut = ValidadorEmail('qualquer_campo');
  });

  test('Deveria retornar null se o email estiver vazio', () {
    expect(sut.valida({'qualquer_campo': ''}), null);
  });

  test('Deveria retornar null se o email estiver vazio', () {
    expect(sut.valida({'qualquer_campo': null}), null);
  });

  test('Deveria retornar null se o email for valido', () {
    expect(sut.valida({'qualquer_campo': 'dev@bruno.penha.nom.br'}), null);
  });

  test('Deveria retornar erro se o email for invalido', () {
    expect(sut.valida({'qualquer_campo': 'bruno.penha.nom.br'}), ErroValidacao.EMAIL_INVALIDO);
  });
}
