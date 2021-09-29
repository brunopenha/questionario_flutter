import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apresentador_acesso.dart';

class EntradaSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentadorAcesso>(context);
    return StreamBuilder<String>(
      stream: apresentacao.senhaComErroStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Senha',
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
          ),
          obscureText: true,
          onChanged: apresentacao.validaSenha,
        );
      },
    );
  }
}
