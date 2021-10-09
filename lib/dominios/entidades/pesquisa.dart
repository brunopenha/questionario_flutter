import 'package:meta/meta.dart';

class Pesquisa {
  final String id;
  final String pergunta;
  final DateTime data;
  final bool respondida;

  Pesquisa({@required this.id, @required this.pergunta, @required this.data, @required this.respondida});
}
