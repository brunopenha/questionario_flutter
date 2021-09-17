import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entidades/conta.dart';

abstract class Autenticador {
  Future<Conta> autoriza(ParametrosAutenticador parametros);
}

class ParametrosAutenticador extends Equatable {
  final String email;
  final String senha;

  ParametrosAutenticador({@required this.email, @required this.senha});

  @override
  List get props => [email, senha];
}
