import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../iu/internacionalizacao/i18n/i18n.dart';
import '../../../erros/erros.dart';
import '../inscricao.dart';

class EntradaEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentadorInscricao>(context);
    return StreamBuilder<ErrosIU>(
      stream: apresentacao.emailComErroStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.email,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
            // Validamos se o erro é diferente de nulo, retorna o erro
            errorText: snapshot.hasData ? snapshot.data.descricao : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: apresentacao.validaEmail,
        );
      },
    );
  }
}
