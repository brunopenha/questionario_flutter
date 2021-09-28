import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/cache/cache.dart';
import 'package:questionario/dados/casosuso/carrega_conta_atual/carrega_conta_atual.dart';
import 'package:questionario/dominios/entidades/entidades.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:test/test.dart';

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
