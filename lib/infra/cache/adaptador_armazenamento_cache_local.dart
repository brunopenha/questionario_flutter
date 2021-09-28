import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../dados/cache/cache.dart';

class AdaptadorArmazenamentoLocal implements SalvaArmazenamentoCacheComSeguranca {
  final FlutterSecureStorage armazenamentoComSeguranca;

  AdaptadorArmazenamentoLocal({@required this.armazenamentoComSeguranca});

  @override
  Future<void> salvaComSeguranca({@required String chave, @required String valor}) async {
    await armazenamentoComSeguranca.write(key: chave, value: valor);
  }
}
