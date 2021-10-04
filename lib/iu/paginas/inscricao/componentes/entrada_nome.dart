import 'package:flutter/material.dart';

import '../../../../iu/internacionalizacao/i18n/i18n.dart';

class EntradaNome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.nome,
        icon: Icon(
          Icons.person,
          color: Theme.of(context).primaryColorLight,
        ),
        // Validamos se o erro é diferente de nulo, retorna o erro
      ),
      keyboardType: TextInputType.name,
    );
  }
}
