import 'package:flutter/widgets.dart';

class Conta {
  final String token;

  Conta({@required this.token});

  factory Conta.doJson(Map json) => 
    Conta(token: json['tokenAcesso']);
}