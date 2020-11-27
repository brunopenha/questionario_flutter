import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart'; // Para incluir parametros obrigatorios

class AutenticacaoRemota {
  final ClienteHttp clienteHttp;
  final String url;

  AutenticacaoRemota({
    @required this.clienteHttp,
    @required this.url
  });

  Future<void> autoriza() async {
    await clienteHttp.requisita(url: url);
  }
}

abstract class ClienteHttp{
  Future<void> requisita({
    @required String url
  }){}
}

class ClienteHttpSimulado extends Mock implements ClienteHttp {}

void main(){
  
  test("Deveria chamar o ClienteHttp com a URL correta", () async{

    final clienteHttp = ClienteHttpSimulado();
    final urlFake = faker.internet.httpUrl();
    // sut - System Under Test
    final sut = AutenticacaoRemota(clienteHttp:clienteHttp, url: urlFake);
    
    await sut.autoriza();

    verify(clienteHttp.requisita(url:urlFake));
  });
}