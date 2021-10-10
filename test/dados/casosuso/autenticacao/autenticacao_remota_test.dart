import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/casosuso/casosuso.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:test/test.dart';

class ClienteHttpSimulado extends Mock implements ClienteHttp<Map> {}

void main() {
  // sut - System Under Test - "Quem estou testando?"
  AutenticacaoRemota sut;

  ClienteHttpSimulado clienteHttp;
  String urlSimulada;
  ParametrosAutenticador parametros;

  Map mockDadosValidos() =>
      {'tokenAcesso': faker.guid.guid(), 'nome': faker.person.name()};

  PostExpectation requisicaoMockada() => when(clienteHttp.requisita(
      caminho: anyNamed('caminho'),
      metodo: anyNamed('metodo'),
      corpo: anyNamed('corpo')));

  void mockDadosHttp(Map dados) {
    requisicaoMockada().thenAnswer((_) async => dados);
  }

  void mockErrosHttp(ErrosHttp erro) {
    requisicaoMockada().thenThrow(erro);
  }

  setUp(() {
    clienteHttp = ClienteHttpSimulado();
    urlSimulada = faker.internet.httpUrl();
    sut = AutenticacaoRemota(clienteHttp: clienteHttp, url: urlSimulada);
    parametros = ParametrosAutenticador(
        email: faker.internet.email(), senha: faker.internet.password());
    mockDadosHttp(mockDadosValidos());
  });

  test("Deveria chamar o ClienteHttp com a URL correta", () async {
    await sut.autoriza(parametros);

    verify(clienteHttp.requisita(
        caminho: urlSimulada,
        metodo: 'post',
        corpo: {'email': parametros.email, 'password': parametros.senha}));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 400", () async {
    mockErrosHttp(ErrosHttp.badRequest);

    final future = sut.autoriza(parametros);

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 404", () async {
    mockErrosHttp(ErrosHttp.notFound);

    final future = sut.autoriza(parametros);

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 500", () async {
    mockErrosHttp(ErrosHttp.serverError);

    final future = sut.autoriza(parametros);

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar CredenciaisInvalidas se o ClienteHttp retornar 401",
      () async {
    mockErrosHttp(ErrosHttp.unauthorized);

    final future = sut.autoriza(parametros);

    expect(future, throwsA(ErrosDominio.credenciaisInvalidas));
  });

  test("Deveria retornar uma conta se o ClienteHttp retornar 200", () async {
    final dadosValidos = mockDadosValidos();

    mockDadosHttp(dadosValidos);

    final conta = await sut.autoriza(parametros);

    expect(conta.token, dadosValidos['tokenAcesso']);
  });

  test(
      "Deveria retornar ErroNaoEsperado se o ClienteHttp retornar 200 com dados invalidos",
      () async {
    mockDadosHttp({'tokenAcesso': 'chave_invalida'});

    final future = sut.autoriza(parametros);
    expect(future, throwsA(ErrosDominio.inesperado));
  });
}
