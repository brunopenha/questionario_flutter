import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:questionario/dados/casosuso/casosuso.dart';



class ClienteHttpSimulado extends Mock implements ClienteHttp {}

void main(){
  
  // sut - System Under Test
  AutenticacaoRemota
   sut;
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
      corpo: { 'email': parametro.email,'senha': parametro.senha}
      ));


  });
}