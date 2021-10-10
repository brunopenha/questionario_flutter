import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/http/cliente_http.dart';
import 'package:test/test.dart';

class CarregaPesquisasRemota {
  final String caminho;
  final ClienteHttp clienteHttp;

  CarregaPesquisasRemota({@required this.caminho, @required this.clienteHttp});

  Future<void> carrega() async {
    await clienteHttp.requisita(caminho: caminho, metodo: 'get');
  }
}

class ClienteHttpSimulado extends Mock implements ClienteHttp {}

void main() {
  test('Deveria chamar o ClienteHttp com os valores corretos', () async {
    final url = faker.internet.httpUrl();
    final clienteHttp = ClienteHttpSimulado();

    final sut = CarregaPesquisasRemota(caminho: url, clienteHttp: clienteHttp);

    await sut.carrega();

    verify(clienteHttp.requisita(caminho: url, metodo: 'get'));
  });
}
