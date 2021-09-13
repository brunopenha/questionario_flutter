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
    await cliente.post(url, headers: cabecalho);
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
      await sut.request(url: url, metodo: 'post');

      verify(cliente.post(url, headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      }));
    });
  });
}
