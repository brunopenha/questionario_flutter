import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../dados/cache/cache.dart';

class AdaptadorArmazenamentoLocal
    implements SalvaArmazenamentoCacheComSeguranca, ObtemCacheArmazenadoComSeguranca {
  final FlutterSecureStorage armazenamentoComSeguranca;

  AdaptadorArmazenamentoLocal({@required this.armazenamentoComSeguranca});

  @override
  Future<void> salvaComSeguranca({@required String chave, @required String valor}) async {
    await armazenamentoComSeguranca.write(key: chave, value: valor);
  }

  @override
  Future<String> obtemComSeguranca(String chave) async {
    return await armazenamentoComSeguranca.read(key: chave);
  }
}
