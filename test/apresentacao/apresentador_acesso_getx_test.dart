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

class SalvaContaAtualSimulado extends Mock implements SalvaContaAtual {}

void main() {
  ApresentacaoAcessoGetx sut;
  ValidadorSimulado validadorSimulado;
  AutenticadorSimulado autenticadorSimulado;
  SalvaContaAtualSimulado salvaContaAtualSimulado;

  String textoEmail;
  String textoSenha;
  String textoToken;

  PostExpectation chamadaValidadorSimulado(String campoParam) => when(validadorSimulado.valida(
      campo: campoParam == null ? anyNamed('campo') : campoParam, entrada: anyNamed('entrada')));

  void chamaValidadorSimulado({String campo, ErroValidacao valor}) {
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
    sut = ApresentacaoAcessoGetx(
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
    final dadosFormulario = {'email': textoEmail, 'senha': null};

    sut.validaEmail(textoEmail);

    verify(validadorSimulado.valida(campo: 'email', entrada: dadosFormulario)).called(1);
  });

  test('Deveria transmitir mensagem de dado inválido no email se o email for inválido', () {
    chamaValidadorSimulado(valor: ErroValidacao.DADO_INVALIDO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.emailComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.DADO_INVALIDO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaEmail(textoEmail);
  });

  test('Deveria transmitir a mensagem de campo obrigatório no email se o email estiver vazio', () {
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

  test('Deveria chamar o Validador com a senha correta', () {
    final dadosFormulario = {'email': null, 'senha': textoSenha};

    sut.validaSenha(textoSenha);

    verify(validadorSimulado.valida(campo: 'senha', entrada: dadosFormulario)).called(1);
  });

  test('Deveria transmitir erro na senha se estiver vazia', () {
    chamaValidadorSimulado(valor: ErroValidacao.CAMPO_OBRIGATORIO);

    // O ouvinte abaixo cada captura do erro
    // Se executar mais de uma vez, o teste falha
    sut.senhaComErroStream.listen(expectAsync1((erro) => expect(erro, ErrosIU.CAMPO_OBRIGATORIO)));

    sut.camposSaoValidosStream.listen(expectAsync1((estaValido) => expect(estaValido, false)));

    sut.validaSenha(textoSenha);
    sut.validaSenha(textoSenha);
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

    expectLater(sut.falhaAcessoStream, emitsInOrder([null, ErrosIU.CREDENCIAIS_INVALIDAS]));

    expectLater(
        sut.paginaEstaCarregandoStream,
        emitsInOrder([
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    await sut.autenticacao();
  });

  test('Deveria transmitir o evento quando houver erro inesperado', () async {
    chamaAutenticadorSimuladoComErro(ErrosDominio.inesperado);

    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    expectLater(sut.falhaAcessoStream, emitsInOrder([null, ErrosIU.INESPERADO]));
    expectLater(
        sut.paginaEstaCarregandoStream,
        emitsInOrder([
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    await sut.autenticacao();
  });

  test('Deveria habilitar o botao caso todos os campos são validos', () async {
    expectLater(sut.camposSaoValidosStream, emitsInOrder([false, true]));

    sut.validaEmail(textoEmail);
    await Future.delayed(Duration.zero);
    sut.validaSenha(textoSenha);
    await Future.delayed(Duration.zero);

    await sut.autenticacao();

    verify(autenticadorSimulado.autoriza(ParametrosAutenticador(email: textoEmail, senha: textoSenha)));
  });

  test('Deveria chamar Autenticador com os valores corretos', () async {
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    await sut.autenticacao();

    verify(autenticadorSimulado.autoriza(ParametrosAutenticador(email: textoEmail, senha: textoSenha)))
        .called(1);
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

    expectLater(sut.falhaAcessoStream, emitsInOrder([null, ErrosIU.INESPERADO]));
    expectLater(
        sut.paginaEstaCarregandoStream,
        emitsInOrder([
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    await sut.autenticacao();
  });

  test('Deveria transmitir os eventos corretos quando Autenticacao não tiver erro', () async {
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    expectLater(sut.falhaAcessoStream, emits(null));
    expectLater(sut.paginaEstaCarregandoStream, emits(true));

    await sut.autenticacao();
  });

  test('Deveria mudar de pagina em caso de sucesso', () async {
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);

    sut.navegaParaStream.listen((pagina) => expect(pagina, '/pesquisas'));

    await sut.autenticacao();
  });

  test('Deveria ir para PaginaInscricao quando o botao for pressionado', () async {
    sut.navegaParaStream.listen((pagina) => expect(pagina, '/inscricao'));
    sut.vaParaInscricao();
  });
}
