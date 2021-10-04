import 'package:flutter/material.dart';

import '../../../../iu/internacionalizacao/i18n/i18n.dart';

class EntradaSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.senha,
        icon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      obscureText: true,
    );
  }
}
