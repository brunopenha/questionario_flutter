import 'package:flutter/widgets.dart';

import '../../dominios/entidades/entidades.dart';
import '../http/http.dart';

class ModeloContaRemota {
  final String tokenAcesso;

  ModeloContaRemota({@required this.tokenAcesso});

  factory ModeloContaRemota.doJson(Map json) {
    if (json.containsValue('chave_invalida')) {
      throw ErrosHttp.invalidData;
    }
    return ModeloContaRemota(tokenAcesso: json['tokenAcesso']);
  }

  Conta paraEntidade() => Conta(token: tokenAcesso);
}
