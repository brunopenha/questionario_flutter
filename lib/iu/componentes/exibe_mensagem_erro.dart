import 'package:flutter/material.dart';

void exibeMensagemErro(BuildContext context, String erro) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(
        erro,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
