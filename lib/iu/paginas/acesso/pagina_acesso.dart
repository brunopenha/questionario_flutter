import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../componentes/componentes.dart';
import 'apresentacao_acesso.dart';
import 'componentes/componentes.dart';

class PaginaAcesso extends StatefulWidget {
  final ApresentacaoAcesso apresentacao;

  const PaginaAcesso(this.apresentacao);

  @override
  _PaginaAcessoState createState() => _PaginaAcessoState();
}

class _PaginaAcessoState extends State<PaginaAcesso> {
  void _escondeTeclado() {
    final focoAtual = FocusScope.of(context);
    if (!focoAtual.hasPrimaryFocus) {
      focoAtual.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.apresentacao.liberaMemoria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        widget.apresentacao.estaCarregandoStream.listen((estaCarregando) {
          if (estaCarregando) {
            exibeCarregando(context);
          } else {
            escondeCarregando(context);
          }
        });

        widget.apresentacao.falhaAcessoStream.listen((erro) {
          if (erro != null) {
            exibeMensagemErro(context, erro);
          }
        });

        return GestureDetector(
          onTap: _escondeTeclado,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CabecalhoAcesso(),
                Titulo1(
                  texto: 'Login',
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => widget
                        .apresentacao, // Estou compartilhando esse presenter com toda a arvore de filhos
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          EntradaEmail(),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 32),
                            child: EntradaSenha(),
                          ),
                          BotaoAcesso(),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.person),
                            label: Text('Criar Conta'),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
