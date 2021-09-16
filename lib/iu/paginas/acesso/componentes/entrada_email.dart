import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../paginas.dart';

class EntradaEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apresentacao = Provider.of<ApresentacaoAcesso>(context);
    return StreamBuilder<String>(
      stream: apresentacao.emailComErroStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: apresentacao.validaEmail,
        );
      },
    );
  }
}
