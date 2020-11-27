import 'package:meta/meta.dart';

import '../entidades/Conta.dart';

abstract class Autenticacao{
  Future<Conta> autoriza({
    @required String email,
    @required String senha
  });
}