import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
//
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/apresentacao/dependencias/dependencias.dart';
import 'package:questionario/iu/erros/erros.dart';

class ValidadorSimulado extends Mock implements Validador {}

void main() {
  ApresentacaoInscricaoGetx sut;
  ValidadorSimulado validadorSimulado;

  String textoEmail;
  String textoNome;
  String textoSenha;
  String textoConfirmaSenha;

  PostExpectation chamadaValidadorSimulado(String campoParam) => when(validadorSimulado.valida(
      campo: campoParam == null ? anyNamed('campo') : campoParam, valor: anyNamed('valor')));

  void chamaValidadorSimulado({String campo, ErroValidacao valor}) {
    chamadaValidadorSimulado(campo).thenReturn(valor);
  }

  setUp(() {
    validadorSimulado = ValidadorSimulado();
    sut = ApresentacaoInscricaoGetx(validador: validadorSimulado);
    textoEmail = faker.internet.email();
    textoNome = faker.person.name();
    textoSenha = faker.internet.password();
    textoConfirmaSenha = faker.internet.password();

    chamaValidadorSimulado();
  });

  test('Deveria chamar o Validador com o email correto', () {
    sut.validaEmail(textoEmail);

    verify(validadorSimulado.valida(campo: 'email', valor: textoEmail)).called(1);
  });

  test('Deveria transmitir mensagem de dado inválido no campo email se o email for inválido', () {
    chamaValidadorSimulado(valor: ErroValidacao.DADO_INVALIDO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.DADO_INVALIDO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaEmail(textoEmail);
  });

  test('Deveria transmitir a mensagem de campo obrigatório no campo email se o email estiver vazio', () {
    chamaValidadorSimulado(valor: ErroValidacao.CAMPO_OBRIGATORIO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.CAMPO_OBRIGATORIO)));

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

  test('Deveria chamar o Validador com o nome correto', () {
    sut.validaNome(textoNome);

    verify(validadorSimulado.valida(campo: 'nome', valor: textoNome)).called(1);
  });

  test('Deveria transmitir mensagem de dado inválido no campo nome se o nome for inválido', () {
    chamaValidadorSimulado(valor: ErroValidacao.DADO_INVALIDO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.nomeComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.DADO_INVALIDO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaNome(textoNome);
  });

  test('Deveria transmitir a mensagem de campo obrigatório no campo nome se o nome estiver vazio', () {
    chamaValidadorSimulado(valor: ErroValidacao.CAMPO_OBRIGATORIO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.nomeComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.CAMPO_OBRIGATORIO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaNome(textoNome);
    sut.validaNome(textoNome);
  });

  test('Deveria transmitir null se a validacao não conter erros', () {
    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.nomeComErroStream.listen(expectAsync1((erro) => expect(erro, null)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaNome(textoNome);
    sut.validaNome(textoNome);
  });

  test('Deveria chamar o Validador com a senha correta', () {
    sut.validaSenha(textoSenha);

    verify(validadorSimulado.valida(campo: 'senha', valor: textoSenha)).called(1);
  });

  test('Deveria transmitir mensagem de dado inválido no campo senha se a senha for inválida', () {
    chamaValidadorSimulado(valor: ErroValidacao.DADO_INVALIDO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.DADO_INVALIDO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaSenha(textoSenha);
  });

  test('Deveria transmitir a mensagem de campo obrigatório no campo senha se a senha estiver vazio', () {
    chamaValidadorSimulado(valor: ErroValidacao.CAMPO_OBRIGATORIO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.CAMPO_OBRIGATORIO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaSenha(textoSenha);
    sut.validaSenha(textoSenha);
  });

  test('Deveria transmitir null se a validacao não conter erros', () {
    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, null)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaSenha(textoSenha);
    sut.validaSenha(textoSenha);
  });

  test('Deveria chamar o Validador com a confirmação da senha correta', () {
    sut.validaConfirmaSenha(textoConfirmaSenha);

    verify(validadorSimulado.valida(campo: 'confirmaSenha', valor: textoConfirmaSenha)).called(1);
  });

  test(
      'Deveria transmitir mensagem de dado inválido no campo confirmaSenha se a confirmação da senha for inválida',
      () {
    chamaValidadorSimulado(valor: ErroValidacao.DADO_INVALIDO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.confirmaSenhaComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.DADO_INVALIDO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaConfirmaSenha(textoConfirmaSenha);
  });

  test('Deveria transmitir a mensagem de campo obrigatório no campo senha se a senha estiver vazio', () {
    chamaValidadorSimulado(valor: ErroValidacao.CAMPO_OBRIGATORIO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.confirmaSenhaComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.CAMPO_OBRIGATORIO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaConfirmaSenha(textoConfirmaSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);
  });

  test('Deveria transmitir null se a validacao não conter erros', () {
    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.confirmaSenhaComErroStream.listen(expectAsync1((erro) => expect(erro, null)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaConfirmaSenha(textoConfirmaSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);
  });

  test('Deveria habilitar o botao caso todos os campos são validos', () async {
    expectLater(sut.camposSaoValidosStream, emitsInOrder([false, true]));

    sut.validaNome(textoNome);
    await Future.delayed(Duration.zero);
    sut.validaEmail(textoEmail);
    await Future.delayed(Duration.zero);
    sut.validaSenha(textoSenha);
    await Future.delayed(Duration.zero);
    sut.validaConfirmaSenha(textoConfirmaSenha);
    await Future.delayed(Duration.zero);
  });
}
