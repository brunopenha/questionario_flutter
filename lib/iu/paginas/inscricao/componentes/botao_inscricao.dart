import 'package:flutter/material.dart';
import 'package:questionario/iu/internacionalizacao/i18n/i18n.dart';

class BotaoInscricao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: null,
      child: Text(R.strings.adicionaConta.toUpperCase()),
    );
  }
}
