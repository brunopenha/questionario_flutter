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
  String url;
  ClienteHttp clienteHttp;
  CarregaPesquisasRemota sut;

  setUp(() {
    url = faker.internet.httpUrl();
    clienteHttp = ClienteHttpSimulado();
    sut = CarregaPesquisasRemota(caminho: url, clienteHttp: clienteHttp);
  });

  test('Deveria chamar o ClienteHttp com os valores corretos', () async {
    await sut.carrega();

    verify(clienteHttp.requisita(caminho: url, metodo: 'get'));
  });
}
