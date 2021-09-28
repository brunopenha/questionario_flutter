import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/conta.dart';
import 'package:questionario/dominios/erros/erros.dart';
import 'package:test/test.dart';

void main() {
  SalvaContaAtualLocalmente sut;
  Conta conta;
  SalvaArmazenamentoCacheComSeguranca salvaCacheArmazenamentoComSeguranca;

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
    when(salvaCacheArmazenamentoComSeguranca.salvaComSeguranca(
            chave: anyNamed('chave'), valor: anyNamed('valor')))
        .thenThrow(Exception());

    final future = sut.salva(conta);

    expect(future, throwsA(ErrosDominio.inesperado));
  });
}

abstract class SalvaArmazenamentoCacheComSeguranca {
  Future<void> salvaComSeguranca({@required String chave, @required String valor});
}

class SalvaArmazenamentoCacheComSegurancaSimulado extends Mock
    implements SalvaArmazenamentoCacheComSeguranca {}

class SalvaContaAtualLocalmente implements SalvaContaAtual {
  final SalvaArmazenamentoCacheComSeguranca salvaArmazenamentoCacheComSeguranca;

  SalvaContaAtualLocalmente({@required this.salvaArmazenamentoCacheComSeguranca});

  @override
  Future<void> salva(Conta conta) async {
    try {
      await salvaArmazenamentoCacheComSeguranca.salvaComSeguranca(chave: 'token', valor: conta.token);
    } catch (erro) {
      throw ErrosDominio.inesperado;
    }
  }
}
