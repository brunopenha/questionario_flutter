import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/cache.dart';

AdaptadorArmazenamentoLocal criaAdaptadorArmazenamentoLocal() {
  final flutterSecureStorage = FlutterSecureStorage();
  return AdaptadorArmazenamentoLocal(armazenamentoComSeguranca: flutterSecureStorage);
}
