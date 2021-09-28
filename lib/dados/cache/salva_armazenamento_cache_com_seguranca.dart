import 'package:meta/meta.dart';

abstract class SalvaArmazenamentoCacheComSeguranca {
  Future<void> salvaComSeguranca({@required String chave, @required String valor});
}
