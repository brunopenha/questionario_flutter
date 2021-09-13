import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class AdaptadorHttp {
  final Client cliente;

  AdaptadorHttp(this.cliente);

  Future<void> request(
      {@required String url, @required String metodo, Map corpo}) async {
    final cabecalho = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final corpoJson = corpo != null ? jsonEncode(corpo) : null;
    await cliente.post(url, headers: cabecalho, body: corpoJson);
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
    test('Deveria chamar o POST com os valores corretos', () async {
      await sut.request(
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
      await sut.request(url: url, metodo: 'post');

      verify(cliente.post(any, headers: anyNamed("headers")));
    });
  });
}
