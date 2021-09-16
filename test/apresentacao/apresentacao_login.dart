import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

abstract class Validador {
  String valida({@required String campo, @required String valor});
}

class ApresentacaoAcessoStream {
  final Validador validador;

  ApresentacaoAcessoStream({@required this.validador});

  void validaEmail(String email) {
    validador.valida(campo: 'email', valor: email);
  }
}

class ValidadorSimulado extends Mock implements Validador {}

void main() {
  test('Deveria chamar o Validador com o email correto', () {
    final validadorSimulado = ValidadorSimulado();
    final sut = ApresentacaoAcessoStream(validador: validadorSimulado);
    final textoEmail = faker.internet.email();

    sut.validaEmail(textoEmail);

    verify(validadorSimulado.valida(campo: 'email', valor: textoEmail)).called(1);
  });
}
