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
    return ErroValidacao.DADO_INVALIDO;
  }
}

void main() {
  test('Deveria retornar um erro se o valor estiver vazio', () {
    final sut = ValidacaoTamanhoMinimo(campo: 'qualquer_campo', tamanho: 5);

    final erro = sut.valida('');

    expectLater(erro, ErroValidacao.DADO_INVALIDO);
  });

  test('Deveria retornar um erro se o valor estiver nulo', () {
    final sut = ValidacaoTamanhoMinimo(campo: 'qualquer_campo', tamanho: 5);

    final erro = sut.valida(null);

    expectLater(erro, ErroValidacao.DADO_INVALIDO);
  });
}
