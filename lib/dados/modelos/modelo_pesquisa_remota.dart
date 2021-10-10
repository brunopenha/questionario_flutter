import 'package:flutter/widgets.dart';

import '../../dados/http/http.dart';
import '../../dominios/entidades/entidades.dart';

class ModeloPesquisaRemota {
  final String id;
  final String pergunta;
  final String data;
  final bool respondida;

  ModeloPesquisaRemota(
      {@required this.id,
      @required this.pergunta,
      @required this.data,
      @required this.respondida});

  factory ModeloPesquisaRemota.doJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw ErrosHttp.invalidData;
    }
    return ModeloPesquisaRemota(
        id: json['id'],
        pergunta: json['question'],
        data: json['date'],
        respondida: json['didAnswer']);
  }

  Pesquisa paraEntidade() => Pesquisa(
      id: id,
      pergunta: pergunta,
      data: DateTime.parse(data),
      respondida: respondida);
}
