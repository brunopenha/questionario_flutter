import 'package:flutter/material.dart';

void exibeCarregando(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // não quero que o usuario consiga clicar de fora do Carregando e fechar
    builder: (context) {
      return SimpleDialog(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Aguarde ... ',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      );
    },
  );
}

void escondeCarregando(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
