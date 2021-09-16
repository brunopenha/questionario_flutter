import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/apresentacao/dependencias/dependencias.dart';

class ValidadorSimulado extends Mock implements Validador {}

void main() {
  ApresentacaoAcessoTransmissor sut;
  ValidadorSimulado validadorSimulado;
  String textoEmail;

  PostExpectation chamadaValidadorSimulado(String campoParam) => when(validadorSimulado.valida(
      campo: campoParam == null ? anyNamed('campo') : campoParam, valor: anyNamed('valor')));

  void chamaValidadorSimulado({String campo, String valor}) {
    chamadaValidadorSimulado(campo).thenReturn(valor);
  }

  setUp(() {
    validadorSimulado = ValidadorSimulado();
    sut = ApresentacaoAcessoTransmissor(validador: validadorSimulado);
    textoEmail = faker.internet.email();

    chamaValidadorSimulado();
  });

  test('Deveria chamar o Validador com o email correto', () {
    sut.validaEmail(textoEmail);

    verify(validadorSimulado.valida(campo: 'email', valor: textoEmail)).called(1);
  });

  test('Deveria transmitir erro no email se a validação falhar', () {
    chamaValidadorSimulado(valor: 'Erro no email');

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, 'Erro no email')));

    sut.validaEmail(textoEmail);
  });
}
