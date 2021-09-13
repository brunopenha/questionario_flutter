import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:test/test.dart';

class AdaptadorHttp implements ClienteHttp {
  final Client cliente;

  AdaptadorHttp(this.cliente);

  @override
  Future<Map> requisita(
      {@required String url, @required String metodo, Map corpo}) async {
    final cabecalho = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final corpoJson = corpo != null ? jsonEncode(corpo) : null;

    final resposta =
        await cliente.post(url, headers: cabecalho, body: corpoJson);

    if (resposta.statusCode == 200) {
      return resposta.body.isEmpty ? null : jsonDecode(resposta.body);
    } else {
      return null;
    }
  }
}

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
  });
}
