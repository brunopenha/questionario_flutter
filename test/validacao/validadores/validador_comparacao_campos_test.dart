import 'package:questionario/apresentacao/dependencias/validador.dart';
import 'package:questionario/validacao/validadores/validadores.dart';
import 'package:test/test.dart';

void main() {
  ValidadorComparaCampos sut;

  setUp(() {
    sut = ValidadorComparaCampos(campo: 'qualquer_campo', campoParaComparar: 'outro_campo');
  });

  test('Deveria retornar um erro se os valores não forem iguais', () {
    final dadosFormulario = {'qualquer_campo': 'qualquer_valor', 'outro_campo': 'outro_valor'};

    expectLater(sut.valida(dadosFormulario), ErroValidacao.DADO_INVALIDO);
  });

  test('Deveria retornar nulo se os valores forem iguais', () {
    final dadosFormulario = {'qualquer_campo': 'qualquer_valor', 'outro_campo': 'qualquer_valor'};
    expectLater(sut.valida(dadosFormulario), null);
  });
}
