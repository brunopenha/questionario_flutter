import 'package:meta/meta.dart';

import '../entidades/conta.dart';

abstract class Autenticacao{
  Future<Conta> autoriza(ParametrosAutenticacao parametros);
}

class ParametrosAutenticacao{
  final String email;
  final String senha;

  ParametrosAutenticacao({
    @required this.email,
    @required this.senha
  });

}