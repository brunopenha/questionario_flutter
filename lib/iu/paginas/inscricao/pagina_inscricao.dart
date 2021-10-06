import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../iu/erros/erros.dart';
import '../../../iu/internacionalizacao/i18n/i18n.dart';
import '../../../iu/paginas/inscricao/inscricao.dart';
import '../../componentes/componentes.dart';
import 'componentes/componentes.dart';

class PaginaInscricao extends StatelessWidget {
  final ApresentadorInscricao apresentador;

  PaginaInscricao(this.apresentador);

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

        apresentador.falhaInscricaoStream.listen((ErrosIU erro) {
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
                  texto: R.strings.adicionaConta,
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => apresentador,
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
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
