import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  ObtemCacheArmazenadoComSegurancaSimulado obtemCacheArmazenadoComSeguranca;
  CarregaContaAtualLocalmente sut;

  setUp(() {
    obtemCacheArmazenadoComSeguranca = ObtemCacheArmazenadoComSegurancaSimulado();
    sut = CarregaContaAtualLocalmente(obtemCacheArmazenadoComSeguranca: obtemCacheArmazenadoComSeguranca);
  });

  test('Deveria chamar ObtemCacheArmazenadoComSeguranca com o valor correto', () async {
    await sut.carrega();

    verify(obtemCacheArmazenadoComSeguranca.obtemComSeguranca('token'));
  });
}

class CarregaContaAtualLocalmente {
  final ObtemCacheArmazenadoComSeguranca obtemCacheArmazenadoComSeguranca;

  CarregaContaAtualLocalmente({@required this.obtemCacheArmazenadoComSeguranca});

  Future<void> carrega() async {
    await obtemCacheArmazenadoComSeguranca.obtemComSeguranca('token');
  }
}

class ObtemCacheArmazenadoComSegurancaSimulado extends Mock implements ObtemCacheArmazenadoComSeguranca {}

abstract class ObtemCacheArmazenadoComSeguranca {
  Future<void> obtemComSeguranca(String chave);
}
