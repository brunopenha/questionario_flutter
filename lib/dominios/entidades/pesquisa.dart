import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Pesquisa extends Equatable {
  final String id;
  final String pergunta;
  final DateTime data;
  final bool respondida;

  @override
  List<Object> get props => ['id', 'pergunta', 'data', 'respondida'];

  Pesquisa(
      {@required this.id,
      @required this.pergunta,
      @required this.data,
      @required this.respondida});
}
