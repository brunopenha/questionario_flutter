import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:questionario/apresentacao/dependencias/validador.dart';
import 'package:questionario/validacao/dependencias/dependencias.dart';
import 'package:test/test.dart';

class ValidacaoTamanhoMinimo implements ValidaCampos {
  final String campo;
  final int tamanho;

  ValidacaoTamanhoMinimo({@required this.campo, @required this.tamanho});

  @override
  ErroValidacao valida(String valor) {
    return valor?.length == tamanho ? null : ErroValidacao.DADO_INVALIDO;
  }
}

void main() {
  ValidacaoTamanhoMinimo sut;

  setUp(() {
    sut = ValidacaoTamanhoMinimo(campo: 'qualquer_campo', tamanho: 5);
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
}
