import 'package:flutter/material.dart';

import '../../../iu/internacionalizacao/i18n/i18n.dart';
import '../../componentes/componentes.dart';
import 'componentes/componentes.dart';

class PaginaInscricao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _escondeTeclado() {
      final focoAtual = FocusScope.of(context);
      if (!focoAtual.hasPrimaryFocus) {
        focoAtual.unfocus();
      }
    }

    return Scaffold(body: Builder(
      builder: (context) {
        return GestureDetector(
          onTap: _escondeTeclado,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CabecalhoAcesso(),
                Titulo1(
                  texto: R.strings.adicionaConta,
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        EntradaNome(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: EntradaEmail(),
                        ),
                        EntradaSenha(),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 32),
                          child: EntradaConfirmarSenha(),
                        ),
                        BotaoInscricao(),
                        FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.exit_to_app),
                          label: Text(R.strings.adicionaConta),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
