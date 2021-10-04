import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../iu/erros/erros.dart';
import '../../../../iu/internacionalizacao/i18n/i18n.dart';
import '../inscricao.dart';

class EntradaNome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentadorInscricao>(context);
    return StreamBuilder<ErrosIU>(
      stream: apresentacao.nomeComErroStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.nome,
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColorLight,
            ),
            // Validamos se o erro é diferente de nulo, retorna o erro
            errorText: snapshot.hasData ? snapshot.data.descricao : null,
          ),
          keyboardType: TextInputType.name,
          onChanged: apresentacao.validaNome,
        );
      },
    );
  }
}
