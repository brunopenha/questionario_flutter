import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionario/iu/erros/erros.dart';

import '../../../../iu/internacionalizacao/i18n/i18n.dart';
import '../inscricao.dart';

class EntradaSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentadorInscricao>(context);
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
            // Validamos se o erro é diferente de nulo, retorna o erro
            errorText: snapshot.hasData ? snapshot.data.descricao : null,
          ),
          obscureText: true,
          onChanged: apresentacao.validaSenha,
        );
      },
    );
  }
}
