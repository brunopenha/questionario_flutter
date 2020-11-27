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
    await clienteHttp.requisita(url: url, metodo:'post');
  }
}

abstract class ClienteHttp{
  Future<void> requisita({
    @required String url,
    @required String metodo
  });
}

class ClienteHttpSimulado extends Mock implements ClienteHttp {}

void main(){
  
  // sut - System Under Test
  AutenticacaoRemota sut;
  ClienteHttpSimulado clienteHttp;
  String urlFake;
  

  setUp(() {
    clienteHttp = ClienteHttpSimulado();
    urlFake = faker.internet.httpUrl();
    sut = AutenticacaoRemota(clienteHttp:clienteHttp, url: urlFake);
    
  });

  test("Deveria chamar o ClienteHttp com a URL correta", () async{

    
    await sut.autoriza();

    verify(clienteHttp.requisita(url:urlFake, metodo:'post'));


  });
}