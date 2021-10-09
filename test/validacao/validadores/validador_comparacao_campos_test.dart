import 'package:questionario/apresentacao/dependencias/validador.dart';
import 'package:questionario/validacao/validadores/validadores.dart';
import 'package:test/test.dart';

void main() {
  ValidadorComparaCampos sut;

  setUp(() {
    sut = ValidadorComparaCampos(campo: 'qualquer_campo', valorParaComparar: 'qualquer_valor');
  });

  test('Deveria retornar um erro se o valor não for igual', () {
    expectLater(sut.valida('valor_errado'), ErroValidacao.DADO_INVALIDO);
  });
}
