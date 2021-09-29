import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apresentador_acesso.dart';

class BotaoAcesso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentadorAcesso>(context);

    return StreamBuilder(
      stream: apresentacao.camposSaoValidosStream,
      builder: (context, snapshot) {
        return RaisedButton(
          onPressed: snapshot.data == true ? apresentacao.autenticacao : null,
          child: Text('Entrar'.toUpperCase()),
        );
      },
    );
  }
}
