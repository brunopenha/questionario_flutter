import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apresentacao_acesso.dart';

class BotaoAcesso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentacaoAcesso>(context);

    return StreamBuilder(
      stream: apresentacao.camposSaoValidosStream,
      builder: (context, snapshot) {
        return RaisedButton(
          onPressed: snapshot.data == true ? apresentacao.autenticador : null,
          child: Text('Entrar'.toUpperCase()),
        );
      },
    );
  }
}
