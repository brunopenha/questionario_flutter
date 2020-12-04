import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart'; // Para incluir parametros obrigatorios

import 'package:questionario/dominios/casosuso/casosuso.dart';

class AutenticacaoRemota {
  final ClienteHttp clienteHttp;
  final String url;

  AutenticacaoRemota({
    @required this.clienteHttp,
    @required this.url
  });

  Future<void> autoriza(ParametrosAutenticacao parametro) async {
    final body = {'email':parametro.email, 'senha':parametro.senha};
    await clienteHttp.requisita(url: url, metodo:'post', body: body);
  }
}

abstract class ClienteHttp{
  Future<void> requisita({
    @required String url,
    @required String metodo,
    Map body
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

    final ParametrosAutenticacao parametro = ParametrosAutenticacao(email: faker.internet.email(), senha: faker.internet.password());    
    await sut.autoriza(parametro);

    verify(clienteHttp.requisita(
      url:urlFake, 
      metodo:'post',
      body: { 'email': parametro.email,'senha': parametro.senha}
      ));


  });
}