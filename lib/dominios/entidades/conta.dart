import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Conta extends Equatable {
  final String token;

  Conta({@required this.token});

  // o Equatable compara os valores, mesmo de referencias diferentes
  @override
  List<Object> get props => [token];
}
