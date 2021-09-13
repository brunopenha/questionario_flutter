import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../dados/http/http.dart';

class AdaptadorHttp implements ClienteHttp {
  final Client cliente;

  AdaptadorHttp(this.cliente);

  @override
  Future<Map> requisita(
      {@required String url, @required String metodo, Map corpo}) async {
    final cabecalho = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final corpoJson = corpo != null ? jsonEncode(corpo) : null;

    final resposta =
        await cliente.post(url, headers: cabecalho, body: corpoJson);

    return _trataRetorno(resposta);
  }

  Map _trataRetorno(Response resposta) {
    if (resposta.statusCode == 200) {
      return resposta.body.isEmpty ? null : jsonDecode(resposta.body);
    } else if (resposta.statusCode == 204) {
      return null;
    } else {
      throw ErrosHttp.badRequest;
    }
  }
}
