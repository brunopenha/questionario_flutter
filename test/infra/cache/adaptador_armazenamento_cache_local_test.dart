import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/infra/cache/cache.dart';
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

  group('salvaComSeguranca', () {
    void salvaComSegurancaComErroSimulado(FlutterSecureStorageSimulado armazenamentoComSeguranca) {
      when(armazenamentoComSeguranca.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());
    }

    test('Deveria chamar o metodo salvaComSeguranca com os valores corretos', () async {
      await sut.salvaComSeguranca(chave: chave, valor: valor);

      verify(armazenamentoComSeguranca.write(key: chave, value: valor));
    });

    test('Deveria lançar exceção se o metodo salvaComSeguranca lançar exceção', () async {
      salvaComSegurancaComErroSimulado(armazenamentoComSeguranca);
      final future = sut.salvaComSeguranca(chave: chave, valor: valor);

      // estou garantindo que o metodo retorou uma exceção, mas é uma exceção qualquer
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('obtemComSeguranca', () {
    void obtemComSegurancaSimulado() {
      when(armazenamentoComSeguranca.read(key: anyNamed('key'))).thenAnswer((_) async => valor);
    }

    setUp(() {
      obtemComSegurancaSimulado();
    });

    test('Deveria chamar o metodo obtemComSeguranca com os valores corretos', () async {
      await sut.obtemComSeguranca(chave);

      verify(armazenamentoComSeguranca.read(key: chave));
    });

    test('Deveria retornar o valor correto quando houver sucesso', () async {
      final valorObtido = await sut.obtemComSeguranca(chave);

      expect(valorObtido, valor);
    });
  });
}

class FlutterSecureStorageSimulado extends Mock implements FlutterSecureStorage {}
