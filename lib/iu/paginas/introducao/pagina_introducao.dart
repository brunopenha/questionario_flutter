import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import 'introducao.dart';

class PaginaIntroducao extends StatelessWidget {
  final ApresentadorIntroducao apresentador;

  PaginaIntroducao({@required this.apresentador});

  @override
  Widget build(BuildContext context) {
    apresentador.verificaContaAtual();
    return Scaffold(
        appBar: AppBar(
          title: Text('Bruno Penha'),
        ),
        body: Builder(
          builder: (context) {
            apresentador.navegaParaTransmissor.listen((pagina) {
              // Se a pagina existir...
              if (pagina?.isNotEmpty == true) {
                Get.offAllNamed(pagina); //... limpa a tela atual a chama a nova
              }
            });

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
