import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
//
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/apresentacao/dependencias/dependencias.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/entidades.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:questionario/iu/erros/erros.dart';

class ValidadorSimulado extends Mock implements Validador {}

class AdicionaContaSimulado extends Mock implements AdicionaConta {}

class SalvaContaAtualSimulado extends Mock implements SalvaContaAtual {}

void main() {
  ApresentacaoInscricaoGetx sut;
  ValidadorSimulado validadorSimulado;
  AdicionaConta adicionaContaSimulado;
  SalvaContaAtualSimulado salvaContaAtualSimulado;

  String textoEmail;
  String textoNome;
  String textoSenha;
  String textoConfirmaSenha;
  String textoToken;

  PostExpectation chamadaValidadorSimulado(String campoParam) => when(validadorSimulado.valida(
      campo: campoParam == null ? anyNamed('campo') : campoParam, entrada: anyNamed('entrada')));

  void chamaValidadorSimulado({String campo, ErroValidacao valor}) {
    chamadaValidadorSimulado(campo).thenReturn(valor);
  }

  PostExpectation chamadaAdicionaContaSimulado() => when(adicionaContaSimulado.adicionaConta(any));

  void chamaAdicionaContaSimulado() {
    chamadaAdicionaContaSimulado().thenAnswer((_) async => Conta(token: textoToken));
  }

  PostExpectation chamadaSalvaContaAtualSimulado() => when(salvaContaAtualSimulado.salva(any));

  void chamaSalvaContaAtualSimuladoComErro(ErrosDominio erro) {
    chamadaSalvaContaAtualSimulado().thenThrow(erro);
  }

  setUp(() {
    validadorSimulado = ValidadorSimulado();
    adicionaContaSimulado = AdicionaContaSimulado();
    salvaContaAtualSimulado = SalvaContaAtualSimulado();
    sut = ApresentacaoInscricaoGetx(
        validador: validadorSimulado,
        adicionaConta: adicionaContaSimulado,
        salvaContaAtual: salvaContaAtualSimulado);
    textoEmail = faker.internet.email();
    textoNome = faker.person.name();
    textoSenha = faker.internet.password();
    textoConfirmaSenha = faker.internet.password();
    textoToken = faker.guid.guid();

    chamaValidadorSimulado();
    chamaAdicionaContaSimulado();
  });

  test('Deveria chamar o Validador com o email correto', () {
    final dadosFormulario = {'nome': null, 'email': textoEmail, 'senha': null, 'confirmaSenha': null};

    sut.validaEmail(textoEmail);

    verify(validadorSimulado.valida(campo: 'email', entrada: dadosFormulario)).called(1);
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
    final dadosFormulario = {'nome': textoNome, 'email': null, 'senha': null, 'confirmaSenha': null};

    sut.validaNome(textoNome);

    verify(validadorSimulado.valida(campo: 'nome', entrada: dadosFormulario)).called(1);
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
    final dadosFormulario = {'nome': null, 'email': null, 'senha': textoSenha, 'confirmaSenha': null};

    sut.validaSenha(textoSenha);

    verify(validadorSimulado.valida(campo: 'senha', entrada: dadosFormulario)).called(1);
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
    final dadosFormulario = {'nome': null, 'email': null, 'senha': null, 'confirmaSenha': textoConfirmaSenha};

    sut.validaConfirmaSenha(textoConfirmaSenha);

    verify(validadorSimulado.valida(campo: 'confirmaSenha', entrada: dadosFormulario)).called(1);
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

  test('Deveria chamar AdicionaConta com os valores corretos', () async {
    sut.validaNome(textoNome);
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);

    await sut.inscreve();

    verify(adicionaContaSimulado.adicionaConta(ParametrosAdicionaConta(
            nome: textoNome, email: textoEmail, senha: textoSenha, confirmaSenha: textoConfirmaSenha)))
        .called(1);
  });

  test('Deveria chamar o SalvaContaAtual com os valores corretos', () async {
    sut.validaNome(textoNome);
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);

    await sut.inscreve();

    verify(salvaContaAtualSimulado.salva(Conta(token: textoToken))).called(1);
  });

  test('Deveria lançar um erro inesperado se SalvaContaAtual tiver algum erro', () async {
    chamaSalvaContaAtualSimuladoComErro(ErrosDominio.inesperado);

    sut.validaNome(textoNome);
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);

    expectLater(sut.falhaInscricaoStream, emitsInOrder([null, ErrosIU.INESPERADO]));

    expectLater(
        sut.paginaEstaCarregandoStream,
        emitsInOrder([
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    await sut.inscreve();
  });

  test('Deveria transmitir o evento EmailEmUsoErro', () async {
    chamaSalvaContaAtualSimuladoComErro(ErrosDominio.emailEmUso);

    sut.validaNome(textoNome);
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);

    expectLater(sut.falhaInscricaoStream, emitsInOrder([null, ErrosIU.EMAIL_EM_USO]));

    expectLater(
        sut.paginaEstaCarregandoStream,
        emitsInOrder([
          true,
          false
        ])); // Por enquanto não é possível verificar quando a tela de carregando foi ativada, apenas quando foi desativada

    await sut.inscreve();
  });

  test('Deveria transmitir os eventos corretos quando AdicionaConta não tiver erro', () async {
    sut.validaNome(textoNome);
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);

    expectLater(sut.falhaInscricaoStream, emits(null));
    expectLater(sut.paginaEstaCarregandoStream, emits(true));

    await sut.inscreve();
  });

  test('Deveria mudar de pagina em caso de sucesso', () async {
    sut.validaNome(textoNome);
    sut.validaEmail(textoEmail);
    sut.validaSenha(textoSenha);
    sut.validaConfirmaSenha(textoConfirmaSenha);

    sut.navegaParaStream.listen((pagina) => expect(pagina, '/acesso'));

    await sut.inscreve();
  });

  test('Deveria ir para PaginaAcesso quando o botao for pressionado', () async {
    sut.navegaParaStream.listen((pagina) => expect(pagina, '/acesso'));
    sut.vaParaAcesso();
  });
}
