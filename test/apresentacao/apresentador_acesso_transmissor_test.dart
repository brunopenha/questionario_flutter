import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
//
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/apresentacao/dependencias/dependencias.dart';
//
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/entidades.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:questionario/iu/erros/erros.dart';

class ValidadorSimulado extends Mock implements Validador {}

class AutenticadorSimulado extends Mock implements Autenticador {}

void main() {
  ApresentacaoAcessoTransmissor sut;
  ValidadorSimulado validadorSimulado;
  AutenticadorSimulado autenticadorSimulado;

  String textoEmail;

  String textoSenha;

  PostExpectation chamadaValidadorSimulado(String campoParam) => when(validadorSimulado.valida(
      campo: campoParam == null ? anyNamed('campo') : campoParam, valor: anyNamed('valor')));

  void chamaValidadorSimulado({String campo, ErroValidacao valor}) {
    chamadaValidadorSimulado(campo).thenReturn(valor);
  }

  PostExpectation chamadaAutenticadorSimulado() => when(autenticadorSimulado.autoriza(any));

  void chamaAutenticadorSimulado({String campo, String valor}) {
    chamadaAutenticadorSimulado().thenAnswer((_) async => Conta(token: faker.guid.guid()));
  }

  void chamaAutenticadorSimuladoComErro(ErrosDominio erro) {
    chamadaAutenticadorSimulado().thenThrow(erro);
  }

  setUp(() {
    validadorSimulado = ValidadorSimulado();
    autenticadorSimulado = AutenticadorSimulado();
    sut = ApresentacaoAcessoTransmissor(validador: validadorSimulado, autenticador: autenticadorSimulado);
    textoEmail = faker.internet.email();
    textoSenha = faker.internet.password();

    chamaValidadorSimulado();
    chamaAutenticadorSimulado();
  });

  test('Deveria chamar o Validador com o email correto', () {
    sut.validaEmail(textoEmail);

    verify(validadorSimulado.valida(campo: 'email', valor: textoEmail)).called(1);
  });

  test('Deveria transmitir erro no email se a validação falhar', () {
    chamaValidadorSimulado(valor: ErroValidacao.EMAIL_INVALIDO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.EMAIL_INVALIDO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaEmail(textoEmail);
    sut.validaEmail(textoEmail);
  });

  test('Deveria transmitir null se a validacao não conter erros', () {
    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, null)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaEmail(textoEmail);
    sut.validaEmail(textoEmail);
  });

  test('Deveria chamar o Validador com a senha correta', () {
    sut.validaSenha(textoSenha);

    verify(validadorSimulado.valida(campo: 'senha', valor: textoSenha)).called(1);
  });

  test('Deveria transmitir erro na senha se a validação falhar', () {
    chamaValidadorSimulado(valor: ErroValidacao.DADO_INVALIDO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.DADO_INVALIDO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaSenha(textoSenha);
    sut.validaSenha(textoSenha);
  });

  test('Deveria transmitir null se a validacao não conter erros na senha', () {
    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, null)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaSenha(textoSenha);
    sut.validaSenha(textoSenha);
  });

  test('Deveria transmitir erro se a validacao conter erros apenas no email', () {
    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    chamaValidadorSimulado(campo: 'email', valor: ErroValidacao.EMAIL_INVALIDO);

    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.EMAIL_INVALIDO)));
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, null)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);
  });

  test('Deveria transmitir null se a validacao não conter erros', () async {
    // O ouvinte abaixo cada captura do erro
    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, null)));
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, null)));

    expectLater(
        sut.camposSaoValidosStream,
        emitsInOrder(
            [false, true])); // Como foi preenchido apenas o email, os outros campos não foram validados

    sut.validaEmail(textoEmail);
    await Future.delayed(Duration.zero);
    sut.validaSenha(textoSenha);
  });

  test('Deveria chamar o Autenticador para validar se os valores estão corretos', () async {
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    await sut.autenticacao();

    verify(autenticadorSimulado.autoriza(ParametrosAutenticador(email: textoEmail, senha: textoSenha)))
        .called(1);
  });

  test('Deveria transmitir o evento quando houver credenciaisInvalidas', () async {
    chamaAutenticadorSimuladoComErro(ErrosDominio.credenciaisInvalidas);

    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    expectLater(
        sut.estaCarregandoStream,
        emitsInOrder([
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    sut.falhaAcessoStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.CREDENCIAIS_INVALIDAS)));

    await sut.autenticacao();
  });

  test('Deveria transmitir o evento quando houver erro inesperado', () async {
    chamaAutenticadorSimuladoComErro(ErrosDominio.inesperado);

    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    expectLater(
        sut.estaCarregandoStream,
        emitsInOrder([
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    sut.falhaAcessoStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.INESPERADO)));

    await sut.autenticacao();
  });

  test('Não deveria transmitir depois que a tela fechar (liberar memória)', () async {
    expectLater(sut.emailComErroStream, neverEmits(null));

    sut.liberaMemoria();

    sut.validaEmail(textoEmail);
  });
}
