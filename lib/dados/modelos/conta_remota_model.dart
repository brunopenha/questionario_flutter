import 'package:flutter/widgets.dart';

import '../../dominios/entidades/entidades.dart';

import '../http/http.dart';

class ContaRemotaModel {
  final String tokenAcesso;

  ContaRemotaModel({@required this.tokenAcesso});

  factory ContaRemotaModel.doJson(Map json) {
    
    if(json.containsValue('chave_invalida')){
      throw ErrosHttp.invalidData;
    }
    return  ContaRemotaModel(tokenAcesso: json['tokenAcesso']);
  
  }

  Conta paraEntidade() => Conta(token: tokenAcesso);

}