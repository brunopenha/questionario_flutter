import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/entidades.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:test/test.dart';

class CarregaContaAtualLocalmente implements CarregaContaAtual {
  final ObtemCacheArmazenadoComSeguranca obtemCacheArmazenadoComSeguranca;

  CarregaContaAtualLocalmente({@required this.obtemCacheArmazenadoComSeguranca});

  @override
  Future<Conta> carrega() async {
    try {
      final tokenRetornado = await obtemCacheArmazenadoComSeguranca.obtemComSeguranca('token');
      return Conta(token: tokenRetornado);
    } catch (e) {
      throw ErrosDominio.inesperado;
    }
  }
}

abstract class ObtemCacheArmazenadoComSeguranca {
  Future<String> obtemComSeguranca(String chave);
}

class ObtemCacheArmazenadoComSegurancaSimulado extends Mock implements ObtemCacheArmazenadoComSeguranca {}

void main() {
  CarregaContaAtualLocalmente sut;
  ObtemCacheArmazenadoComSegurancaSimulado obtemCacheArmazenadoComSeguranca;
  String textoToken;

  PostExpectation chamaObtemCacheArmazenadoComSegurancaSimulado() =>
      when(obtemCacheArmazenadoComSeguranca.obtemComSeguranca(any));

  void obtemCacheArmazenadoComSegurancaSimulado() {
    chamaObtemCacheArmazenadoComSegurancaSimulado().thenAnswer((_) async => textoToken);
  }

  void obtemCacheArmazenadoComSegurancaComErroSimulado() {
    chamaObtemCacheArmazenadoComSegurancaSimulado().thenThrow(Exception());
  }

  setUp(() {
    obtemCacheArmazenadoComSeguranca = ObtemCacheArmazenadoComSegurancaSimulado();
    sut = CarregaContaAtualLocalmente(obtemCacheArmazenadoComSeguranca: obtemCacheArmazenadoComSeguranca);
    textoToken = faker.guid.guid();
    obtemCacheArmazenadoComSegurancaSimulado();
  });

  test('Deveria chamar ObtemCacheArmazenadoComSeguranca com o valor correto', () async {
    await sut.carrega();

    verify(obtemCacheArmazenadoComSeguranca.obtemComSeguranca('token'));
  });

  test('Deveria retornar a entidade Conta', () async {
    final conta = await sut.carrega();

    expect(conta, Conta(token: textoToken));
  });

  test('Deveria lançar um erro inesperado se houver uma falha em ObtemCacheArmazenadoComSeguranca', () async {
    obtemCacheArmazenadoComSegurancaComErroSimulado();

    final future = sut.carrega();

    expect(future, throwsA(ErrosDominio.inesperado));
  });
}
