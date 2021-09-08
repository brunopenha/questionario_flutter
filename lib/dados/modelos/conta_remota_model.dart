import 'package:flutter/widgets.dart';
import 'package:questionario/dominios/entidades/entidades.dart';

class ContaRemotaModel {
  final String tokenAcesso;

  ContaRemotaModel({@required this.tokenAcesso});

  factory ContaRemotaModel.doJson(Map json) => 
    ContaRemotaModel(tokenAcesso: json['tokenAcesso']);

  Conta paraEntidade() => Conta(token: tokenAcesso);

}