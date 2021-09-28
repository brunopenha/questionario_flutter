import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/conta.dart';
import 'package:test/test.dart';

void main() {
  test('Deveria chamar SalvaArmazenamentoCache com os valores corretos', () async {
    final conta = Conta(token: faker.guid.guid());
    final salvaCacheArmazenamentoComSeguranca = SalvaArmazenamentoCacheComSegurancaSimulado();
    final sut =
        SalvaContaAtualLocalmente(salvaArmazenamentoCacheComSeguranca: salvaCacheArmazenamentoComSeguranca);

    await sut.salva(conta);

    verify(salvaCacheArmazenamentoComSeguranca.salvaComSeguranca(chave: 'token', valor: conta.token));
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
    await salvaArmazenamentoCacheComSeguranca.salvaComSeguranca(chave: 'token', valor: conta.token);
  }
}
