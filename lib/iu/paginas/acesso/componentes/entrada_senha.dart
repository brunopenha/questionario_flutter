import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../iu/erros/erros.dart';
import '../../../../iu/internacionalizacao/i18n/i18n.dart';
import '../apresentador_acesso.dart';

class EntradaSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentadorAcesso>(context);
    return StreamBuilder<ErrosIU>(
      stream: apresentacao.senhaComErroStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.senha,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.hasData ? snapshot.data.descricao : null,
          ),
          obscureText: true,
          onChanged: apresentacao.validaSenha,
        );
      },
    );
  }
}
