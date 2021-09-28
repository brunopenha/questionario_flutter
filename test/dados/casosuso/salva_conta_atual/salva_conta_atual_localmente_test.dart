import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/cache/cache.dart';
import 'package:questionario/dados/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/conta.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:test/test.dart';

void main() {
  SalvaContaAtualLocalmente sut;
  Conta conta;
  SalvaArmazenamentoCacheComSeguranca salvaCacheArmazenamentoComSeguranca;

  void simulaErro() {
    when(salvaCacheArmazenamentoComSeguranca.salvaComSeguranca(
            chave: anyNamed('chave'), valor: anyNamed('valor')))
        .thenThrow(Exception());
  }

  setUp(() {
    conta = Conta(token: faker.guid.guid());
    salvaCacheArmazenamentoComSeguranca = SalvaArmazenamentoCacheComSegurancaSimulado();
    sut = SalvaContaAtualLocalmente(salvaArmazenamentoCacheComSeguranca: salvaCacheArmazenamentoComSeguranca);
  });

  test('Deveria chamar SalvaArmazenamentoCacheComSeguranca com os valores corretos', () async {
    await sut.salva(conta);

    verify(salvaCacheArmazenamentoComSeguranca.salvaComSeguranca(chave: 'token', valor: conta.token));
  });

  test('Deveria lançar erro inesperado se o SalvaArmazenamentoCacheComSeguranca levantar uma exceção',
      () async {
    simulaErro();

    final future = sut.salva(conta);

    expect(future, throwsA(ErrosDominio.inesperado));
  });
}

class SalvaArmazenamentoCacheComSegurancaSimulado extends Mock
    implements SalvaArmazenamentoCacheComSeguranca {}
