import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/cache/cache.dart';
import 'package:test/test.dart';

void main() {
  test('Deveria chamar o metodo salvaComSeguranca com os valores corretos', () async {
    final armazenamentoComSeguranca = FlutterSecureStorageSimulado();
    final sut = AdaptadorArmazenamentoLocal(armazenamentoComSeguranca: armazenamentoComSeguranca);

    final chave = faker.lorem.word();
    final valor = faker.guid.guid();

    await sut.salvaComSeguranca(chave: chave, valor: valor);

    verify(armazenamentoComSeguranca.write(key: chave, value: valor));
  });
}

class AdaptadorArmazenamentoLocal implements SalvaArmazenamentoCacheComSeguranca {
  final FlutterSecureStorage armazenamentoComSeguranca;

  AdaptadorArmazenamentoLocal({@required this.armazenamentoComSeguranca});

  @override
  Future<void> salvaComSeguranca({@required String chave, @required String valor}) async {
    await armazenamentoComSeguranca.write(key: chave, value: valor);
  }
}

class FlutterSecureStorageSimulado extends Mock implements FlutterSecureStorage {}
