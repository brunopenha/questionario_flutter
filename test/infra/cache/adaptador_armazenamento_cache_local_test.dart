import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/cache/cache.dart';
import 'package:test/test.dart';

void main() {
  AdaptadorArmazenamentoLocal sut;
  FlutterSecureStorageSimulado armazenamentoComSeguranca;
  String chave;
  String valor;

  setUp(() {
    armazenamentoComSeguranca = FlutterSecureStorageSimulado();
    sut = AdaptadorArmazenamentoLocal(armazenamentoComSeguranca: armazenamentoComSeguranca);

    chave = faker.lorem.word();
    valor = faker.guid.guid();
  });

  test('Deveria chamar o metodo salvaComSeguranca com os valores corretos', () async {
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
