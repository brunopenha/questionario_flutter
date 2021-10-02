import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/casosuso/adiciona_conta/adiciona_conta.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:test/test.dart';

class ClienteHttpSimulado extends Mock implements ClienteHttp {}

void main() {
  // sut - System Under Test - "Quem estou testando?"
  AdicionaContaRemota sut;

  ClienteHttpSimulado clienteHttp;
  String urlSimulada;
  String senhaSimulada = faker.internet.password();
  ParametrosAdicionaConta parametros;

  PostExpectation requisicaoMockada() =>
      when(clienteHttp.requisita(url: anyNamed('url'), metodo: anyNamed('metodo'), corpo: anyNamed('corpo')));

  Map mockDadosValidos() => {'tokenAcesso': faker.guid.guid(), 'nome': faker.person.name()};

  void mockDadosHttp(Map dados) {
    requisicaoMockada().thenAnswer((_) async => dados);
  }

  void mockErrosHttp(ErrosHttp erro) {
    requisicaoMockada().thenThrow(erro);
  }

  setUp(() {
    clienteHttp = ClienteHttpSimulado();
    urlSimulada = faker.internet.httpUrl();
    sut = AdicionaContaRemota(clienteHttp: clienteHttp, url: urlSimulada);
    parametros = ParametrosAdicionaConta(
        nome: faker.person.name(),
        email: faker.internet.email(),
        senha: senhaSimulada,
        confirmaSenha: senhaSimulada);
    mockDadosHttp(mockDadosValidos());
  });

  test("Deveria chamar o ClienteHttp com a URL correta", () async {
    await sut.adiciona(parametros);

    verify(clienteHttp.requisita(url: urlSimulada, metodo: 'post', corpo: {
      'name': parametros.nome,
      'email': parametros.email,
      'password': parametros.senha,
      'passwordConfirmation': parametros.confirmaSenha
    }));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 400", () async {
    mockErrosHttp(ErrosHttp.badRequest);

    final future = sut.adiciona(parametros);

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 404", () async {
    mockErrosHttp(ErrosHttp.notFound);

    final future = sut.adiciona(parametros);

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 500", () async {
    mockErrosHttp(ErrosHttp.serverError);

    final future = sut.adiciona(parametros);

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar CredenciaisInvalidas se o ClienteHttp retornar 403", () async {
    mockErrosHttp(ErrosHttp.forbidden);

    final future = sut.adiciona(parametros);

    expect(future, throwsA(ErrosDominio.emailEmUso));
  });

  test("Deveria retornar uma conta se o ClienteHttp retornar 200", () async {
    final dadosValidos = mockDadosValidos();

    mockDadosHttp(dadosValidos);

    final conta = await sut.adiciona(parametros);

    expect(conta.token, dadosValidos['tokenAcesso']);
  });
}
