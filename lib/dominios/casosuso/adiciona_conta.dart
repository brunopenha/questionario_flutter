import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entidades/conta.dart';

abstract class AdicionaConta {
  Future<Conta> adicionaConta(ParametrosAdicionaConta parametros);
}

class ParametrosAdicionaConta extends Equatable {
  final String nome;
  final String email;
  final String senha;
  final String confirmaSenha;

  ParametrosAdicionaConta(
      {@required this.nome, @required this.email, @required this.senha, @required this.confirmaSenha});

  @override
  List get props => [nome, email, senha, confirmaSenha];
}
