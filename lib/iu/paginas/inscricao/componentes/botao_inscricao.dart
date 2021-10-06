import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../iu/internacionalizacao/i18n/i18n.dart';
import '../inscricao.dart';

class BotaoInscricao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentadorInscricao>(context);

    return StreamBuilder<bool>(
      stream: apresentacao.camposSaoValidosStream,
      builder: (context, snapshot) {
        return RaisedButton(
          onPressed: snapshot.data == true ? apresentacao.inscreve : null,
          child: Text(R.strings.adicionaConta.toUpperCase()),
        );
      },
    );
  }
}
