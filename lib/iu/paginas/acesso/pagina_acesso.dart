import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../componentes/componentes.dart';
import 'apresentacao_acesso.dart';
import 'componentes/componentes.dart';

class PaginaAcesso extends StatelessWidget {
  final ApresentacaoAcesso apresentacao;

  const PaginaAcesso(this.apresentacao);

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
        apresentacao.estaCarregandoStream.listen((estaCarregando) {
          if (estaCarregando) {
            exibeCarregando(context);
          } else {
            escondeCarregando(context);
          }
        });

        apresentacao.falhaAcessoStream.listen((erro) {
          if (erro != null) {
            exibeMensagemErro(context, erro);
          }
        });

        // Toda vez que receber uma notificacao do NavegarPara
        apresentacao.navegaParaStream.listen((pagina) {
          if (pagina?.isNotEmpty == true) {
            Get.offAllNamed(pagina);
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
                    create: (_) =>
                        apresentacao, // Estou compartilhando esse presenter com toda a arvore de filhos
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
