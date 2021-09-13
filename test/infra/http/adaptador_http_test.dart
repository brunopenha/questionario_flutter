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
    await cliente.post(url);
  }
}

class ClienteSimulado extends Mock implements Client {}

void main() {
  group('post', () {
    test('Deveria chamar o POST com os valores corretos', () async {
      final cliente = ClienteSimulado();
      final sut = AdaptadorHttp(cliente);
      final url = faker.internet.httpUrl();

      await sut.request(url: url, metodo: 'post');

      verify(cliente.post(url));
    });
  });
}
