import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/erros/erros.dart';

import 'package:questionario/dados/http/http.dart';
import 'package:questionario/dados/casosuso/casosuso.dart';



class ClienteHttpSimulado extends Mock implements ClienteHttp {}

void main(){
  
  // sut - System Under Test - "Quem estou testando?"
  AutenticacaoRemota sut;
  
  ClienteHttpSimulado clienteHttp;
  String urlFake;
  ParametrosAutenticacao parametro;

  setUp(() {
    clienteHttp = ClienteHttpSimulado();
    urlFake = faker.internet.httpUrl();
    sut = AutenticacaoRemota(clienteHttp:clienteHttp, url: urlFake);
    parametro = ParametrosAutenticacao(email: faker.internet.email(), senha: faker.internet.password());
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

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 400", () async{

    when(clienteHttp.requisita(url: anyNamed('url'), metodo: anyNamed('metodo'), corpo: anyNamed('corpo')))
      .thenThrow(ErrosHttp.badRequest);
      
    final future = sut.autoriza(parametro);

    expect(future, throwsA(ErrosDominio.inesperado)); 
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 404", () async{

    when(clienteHttp.requisita(url: anyNamed('url'), metodo: anyNamed('metodo'), corpo: anyNamed('corpo')))
      .thenThrow(ErrosHttp.notFounded);
      
    final future = sut.autoriza(parametro);

    expect(future, throwsA(ErrosDominio.inesperado)); 
  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 500", () async{

    when(clienteHttp.requisita(url: anyNamed('url'), metodo: anyNamed('metodo'), corpo: anyNamed('corpo')))
      .thenThrow(ErrosHttp.serverError);
      
    final future = sut.autoriza(parametro);

    expect(future, throwsA(ErrosDominio.inesperado)); 
  });

  test("Deveria lançar CredenciaisInvalidas se o ClienteHttp retornar 401", () async{

    when(clienteHttp.requisita(url: anyNamed('url'), metodo: anyNamed('metodo'), corpo: anyNamed('corpo')))
      .thenThrow(ErrosHttp.unauthorized);
      
    final future = sut.autoriza(parametro);

    expect(future, throwsA(ErrosDominio.credenciaisInvalidas)); 
  });
}