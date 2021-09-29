import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../iu/componentes/componentes.dart';
import 'fabricas/fabricas.dart';

void main() {
  runApp(Aplicativo());
}

class Aplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'Questionário',
      debugShowCheckedModeBanner: false,
      theme: aplicaTemaNoAplicativo(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: criaPaginaIntroducao, transition: Transition.fade),
        GetPage(name: '/acesso', page: criaPaginaAcesso, transition: Transition.fade),
        GetPage(
            name: '/pesquisas',
            page: () => Scaffold(
                  body: Text('Pesquisas'),
                ),
            transition: Transition.fade),
      ],
    );
  }
}
