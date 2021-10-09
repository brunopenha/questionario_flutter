import 'package:faker/faker.dart';
import 'package:questionario/apresentacao/dependencias/validador.dart';
import 'package:questionario/validacao/validadores/validadores.dart';
import 'package:test/test.dart';

void main() {
  ValidadorTamanhoMinimo sut;

  setUp(() {
    sut = ValidadorTamanhoMinimo(campo: 'qualquer_campo', tamanhoCampo: 5);
  });

  test('Deveria retornar um erro se o valor estiver vazio', () {
    expectLater(sut.valida(''), ErroValidacao.DADO_INVALIDO);
  });

  test('Deveria retornar um erro se o valor estiver nulo', () {
    expectLater(sut.valida(null), ErroValidacao.DADO_INVALIDO);
  });

  test('Deveria retornar um erro se o valor abaixo do tamanho minimo', () {
    expectLater(sut.valida(faker.randomGenerator.string(4, min: 1)), ErroValidacao.DADO_INVALIDO);
  });

  test('Deveria retornar um erro se o valor igual ao tamanho minimo', () {
    expectLater(sut.valida(faker.randomGenerator.string(5, min: 5)), null);
  });

  test('Deveria retornar um erro se o valor mairo que o tamanho minimo', () {
    expectLater(sut.valida(faker.randomGenerator.string(10, min: 6)), null);
  });
}
