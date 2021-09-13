import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:questionario/infra/http/http.dart';
import 'package:test/test.dart';

class ClienteSimulado extends Mock implements Client {}

void main() {
  AdaptadorHttp sut;
  ClienteSimulado cliente;
  String url;

  setUp(() {
    cliente = ClienteSimulado();
    sut = AdaptadorHttp(cliente);
    url = faker.internet.httpUrl();
  });

  group('comum', () {
    test('Deveria lançar ServerError se for enviado um metodo HTTP invalido',
        () async {
      final future = sut.requisita(url: url, metodo: 'INVALIDO');

      expect(future, throwsA(ErrosHttp.serverError));
    });
  });

  group('post', () {
    PostExpectation requisicaoMockada() => when(cliente.post(any,
        headers: anyNamed('headers'), body: anyNamed('body')));

    void retornoMockado(int statusCode,
        {String corpo = '{"qualquer_valor" : "qualquer_chave"}'}) {
      requisicaoMockada().thenAnswer((_) async => Response(corpo, statusCode));
    }

    setUp(() {
      retornoMockado(200);
    });

    test('Deveria chamar o POST com os valores corretos', () async {
      await sut.requisita(
          url: url,
          metodo: 'post',
          corpo: {'qualquer_chave': 'qualquer_valor'});

      verify(cliente.post(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"qualquer_chave":"qualquer_valor"}'));
    });

    test('Deveria chamar o POST sem o corpo na requisição', () async {
      await sut.requisita(url: url, metodo: 'post');

      verify(cliente.post(any, headers: anyNamed("headers")));
    });

    test('Deveria retornar algum dado se o POST retornar 200', () async {
      final retorno = await sut.requisita(url: url, metodo: 'post');

      expect(retorno, {'qualquer_valor': 'qualquer_chave'});
    });

    test('Deveria retornar null se o POST retornar 200 sem dados no corpo',
        () async {
      retornoMockado(200, corpo: '');
      final retorno = await sut.requisita(url: url, metodo: 'post');

      expect(retorno, null);
    });

    test('Deveria retornar null se o POST retornar 204', () async {
      retornoMockado(204, corpo: '');
      final retorno = await sut.requisita(url: url, metodo: 'post');

      expect(retorno, null);
    });

    test('Deveria retornar null se o POST retornar 204 com dados', () async {
      retornoMockado(204);
      final retorno = await sut.requisita(url: url, metodo: 'post');

      expect(retorno, null);
    });

    test('Deveria retornar BadRequestError se o POST retornar 400', () async {
      retornoMockado(400);

      final future = sut.requisita(url: url, metodo: 'post');

      expect(future, throwsA(ErrosHttp.badRequest));
    });

    test('Deveria retornar BadRequestError se o POST retornar 400', () async {
      retornoMockado(400, corpo: '');

      final future = sut.requisita(url: url, metodo: 'post');

      expect(future, throwsA(ErrosHttp.badRequest));
    });

    test('Deveria retornar UnauthorizedError se o POST retornar 401', () async {
      retornoMockado(401);

      final future = sut.requisita(url: url, metodo: 'post');

      expect(future, throwsA(ErrosHttp.unauthorized));
    });

    test('Deveria retornar ForbiddenError se o POST retornar 403', () async {
      retornoMockado(403);

      final future = sut.requisita(url: url, metodo: 'post');

      expect(future, throwsA(ErrosHttp.forbidden));
    });

    test('Deveria retornar NorFoundError se o POST retornar 404', () async {
      retornoMockado(404);

      final future = sut.requisita(url: url, metodo: 'post');

      expect(future, throwsA(ErrosHttp.notFound));
    });

    test('Deveria retornar ServerError se o POST retornar 500', () async {
      retornoMockado(500);

      final future = sut.requisita(url: url, metodo: 'post');

      expect(future, throwsA(ErrosHttp.serverError));
    });
  });
}
