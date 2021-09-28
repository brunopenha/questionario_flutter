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

class ValidadorSimulado extends Mock implements Validador {}

class AutenticadorSimulado extends Mock implements Autenticador {}

class SalvaContaAtualSimulado extends Mock implements SalvaContaAtual {}

void main() {
  ApresentacaoAcessoGex sut;
  ValidadorSimulado validadorSimulado;
  AutenticadorSimulado autenticadorSimulado;
  SalvaContaAtualSimulado salvaContaAtualSimulado;

  String textoEmail;
  String textoSenha;
  String textoToken;

  PostExpectation chamadaValidadorSimulado(String campoParam) => when(validadorSimulado.valida(
      campo: campoParam == null ? anyNamed('campo') : campoParam, valor: anyNamed('valor')));

  void chamaValidadorSimulado({String campo, String valor}) {
    chamadaValidadorSimulado(campo).thenReturn(valor);
  }

  PostExpectation chamadaAutenticadorSimulado() => when(autenticadorSimulado.autoriza(any));
  PostExpectation chamadaSalvaContaAtualSimulado() => when(salvaContaAtualSimulado.salva(any));

  void chamaAutenticadorSimulado({String campo, String valor}) {
    chamadaAutenticadorSimulado().thenAnswer((_) async => Conta(token: textoToken));
  }

  void chamaAutenticadorSimuladoComErro(ErrosDominio erro) {
    chamadaAutenticadorSimulado().thenThrow(erro);
  }

  void chamaSalvaContaAtualSimuladoComErro() {
    chamadaSalvaContaAtualSimulado().thenThrow(ErrosDominio.inesperado);
  }

  setUp(() {
    validadorSimulado = ValidadorSimulado();
    autenticadorSimulado = AutenticadorSimulado();
    salvaContaAtualSimulado = SalvaContaAtualSimulado();
    sut = ApresentacaoAcessoGex(
        validador: validadorSimulado,
        autenticador: autenticadorSimulado,
        salvaContaAtual: salvaContaAtualSimulado);
    textoEmail = faker.internet.email();
    textoSenha = faker.internet.password();
    textoToken = faker.guid.guid();

    chamaValidadorSimulado();
    chamaAutenticadorSimulado();
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
    chamaValidadorSimulado(valor: 'Erro na senha');

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, 'Erro na senha')));

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
    chamaValidadorSimulado(campo: 'email', valor: 'Erro no Email');

    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, 'Erro no Email')));
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
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    sut.falhaAcessoStream.listen(expectAsync1((erro) => expect(erro, 'Credenciais inválidas')));

    await sut.autenticacao();
  });

  test('Deveria transmitir o evento quando houver erro inesperado', () async {
    chamaAutenticadorSimuladoComErro(ErrosDominio.inesperado);

    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    expectLater(
        sut.estaCarregandoStream,
        emitsInOrder([
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    sut.falhaAcessoStream
        .listen(expectAsync1((erro) => expect(erro, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.autenticacao();
  });

  test('Deveria chamar o SalvaContaAtual com o valore correto', () async {
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    await sut.autenticacao();

    verify(salvaContaAtualSimulado.salva(Conta(token: textoToken))).called(1);
  });

  test('Deveria lançar um erro inesperado se SalvaContaAtual tiver algum erro', () async {
    chamaSalvaContaAtualSimuladoComErro();

    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    expectLater(
        sut.estaCarregandoStream,
        emitsInOrder([
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    sut.falhaAcessoStream
        .listen(expectAsync1((erro) => expect(erro, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.autenticacao();
  });
}
