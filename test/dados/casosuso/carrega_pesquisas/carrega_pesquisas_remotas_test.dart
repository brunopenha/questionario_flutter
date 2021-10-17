import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/http/cliente_http.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:questionario/dados/modelos/modelos.dart';
import 'package:questionario/dominios/entidades/entidades.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:test/test.dart';

class CarregaPesquisasRemota {
  final String caminho;
  final ClienteHttp<List<Map>> clienteHttp;

  CarregaPesquisasRemota({@required this.caminho, @required this.clienteHttp});

  Future<List<Pesquisa>> carrega() async {
    try {
      final retornoHttp = await clienteHttp.requisita(caminho: caminho, metodo: 'get');
      return retornoHttp.map((json) => ModeloPesquisaRemota.doJson(json).paraEntidade()).toList();
    } on ErrosHttp {
      throw ErrosDominio.inesperado;
    }
  }
}

class ClienteHttpSimulado extends Mock implements ClienteHttp<List<Map>> {}

void main() {
  String url;
  ClienteHttp clienteHttp;
  CarregaPesquisasRemota sut;
  List<Map> listaDados;

  List<Map> simulaDadosValidos() =>
      [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String()
        }
      ];

  PostExpectation requisicaoSimulado() => when(clienteHttp.requisita(caminho: anyNamed('caminho'), metodo: anyNamed('metodo')));

  void simulaDadosHttp(List<Map> dados) {
    listaDados = dados;
    requisicaoSimulado().thenAnswer((_) async => dados);
  }

  void mockErrosHttp(ErrosHttp erro) {
    requisicaoSimulado().thenThrow(erro);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    clienteHttp = ClienteHttpSimulado();
    sut = CarregaPesquisasRemota(caminho: url, clienteHttp: clienteHttp);
    simulaDadosHttp(simulaDadosValidos());
  });

  test('Deveria chamar o ClienteHttp com os valores corretos', () async {
    await sut.carrega();

    verify(clienteHttp.requisita(caminho: url, metodo: 'get'));
  });

  test('Deveria retornar as pesquisas quando receber o codigo 200', () async {
    final pesquisas = await sut.carrega();

    final listaEsperada = [
      Pesquisa(
          id: listaDados[0]['id'], pergunta: listaDados[0]['question'], data: DateTime.parse(listaDados[0]['date']), respondida: listaDados[0]['didAnswer']),
      Pesquisa(
          id: listaDados[1]['id'], pergunta: listaDados[1]['question'], data: DateTime.parse(listaDados[1]['date']), respondida: listaDados[1]['didAnswer'])
    ];

    expectLater(pesquisas, listaEsperada);
  });

  test("Deveria retornar ErroNaoEsperado se o ClienteHttp retornar 200 com dados invalidos", () async {
    simulaDadosHttp([
      {'chave_invalida': 'valor_invalido'}
    ]);

    final future = sut.carrega();

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 404", () async {
    mockErrosHttp(ErrosHttp.notFound);

    final future = sut.carrega();

    expect(future, throwsA(ErrosDominio.inesperado));
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 500", () async {
    mockErrosHttp(ErrosHttp.serverError);

    final future = sut.carrega();

    expect(future, throwsA(ErrosDominio.inesperado));
  });
}
