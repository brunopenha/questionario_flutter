import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../iu/erros/erros.dart';
import '../../../iu/internacionalizacao/i18n/i18n.dart';
import '../../componentes/componentes.dart';
import 'apresentador_acesso.dart';
import 'componentes/componentes.dart';

class PaginaAcesso extends StatelessWidget {
  final ApresentadorAcesso apresentador;

  const PaginaAcesso(this.apresentador);

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
        apresentador.paginaEstaCarregandoStream.listen((estaCarregando) {
          if (estaCarregando) {
            exibeCarregando(context);
          } else {
            escondeCarregando(context);
          }
        });

        apresentador.falhaAcessoStream.listen((ErrosIU erro) {
          if (erro != null) {
            exibeMensagemErro(context, erro.descricao);
          }
        });

        // Toda vez que receber uma notificacao do NavegarPara
        apresentador.navegaParaStream.listen((pagina) {
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
                  texto: R.strings.entrar,
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) =>
                        apresentador, // Estou compartilhando esse presenter com toda a arvore de filhos
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
                            label: Text(R.strings.adicionaConta),
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
