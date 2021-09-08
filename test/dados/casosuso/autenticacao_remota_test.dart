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
  String urlSimulada;
  ParametrosAutenticacao parametro;

  setUp(() {
    clienteHttp = ClienteHttpSimulado();
    urlSimulada = faker.internet.httpUrl();
    sut = AutenticacaoRemota(clienteHttp:clienteHttp, url: urlSimulada);
    parametro = ParametrosAutenticacao(email: faker.internet.email(), senha: faker.internet.password());
  });

  test("Deveria chamar o ClienteHttp com a URL correta", () async{

    when(clienteHttp.requisita(url: anyNamed('url'), metodo: anyNamed('metodo'), corpo: anyNamed('corpo')))
      .thenAnswer((_) async => {'tokenAcesso' : faker.guid.guid(), 'nome' : faker.person.name()});
    
    
    await sut.autoriza(parametro);

    verify(clienteHttp.requisita(
      url:urlSimulada, 
      metodo:'post',
      corpo: { 'email': parametro.email,'senha': parametro.senha}
      ));


  });

  test("Deveria lançar ErroInesperado se o ClienteHttp retornar 400", () async{

    when(
          clienteHttp.requisita(url: anyNamed('url'), 
          metodo: anyNamed('metodo'), 
          corpo: anyNamed('corpo'))
        )
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

   test("Deveria retornar uma conta se o ClienteHttp retornar 200", () async{

    final tokenAcesso = faker.guid.guid();

    when(clienteHttp.requisita(url: anyNamed('url'), metodo: anyNamed('metodo'), corpo: anyNamed('corpo')))
      .thenAnswer((_) async => {'tokenAcesso' : tokenAcesso, 'nome' : faker.person.name()});
      
    final conta = await sut.autoriza(parametro);

    expect(conta.token, tokenAcesso); 
  });
}