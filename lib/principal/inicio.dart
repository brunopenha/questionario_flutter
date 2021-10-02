import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../iu/componentes/componentes.dart';
import '../iu/internacionalizacao/i18n/i18n.dart';
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
      initialRoute: '/acesso',
      getPages: [
        GetPage(name: '/', page: criaPaginaIntroducao, transition: Transition.fade),
        GetPage(name: '/acesso', page: criaPaginaAcesso, transition: Transition.fade),
        GetPage(
            name: '/pesquisas',
            page: () => Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        Text(R.strings.pesquisas),
                        RaisedButton(
                          onPressed: () {
                            R.carrega(Locale('en', 'US'));
                          },
                          child: Text('English'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            R.carrega(Locale('pt', 'BR'));
                          },
                          child: Text('Português'),
                        ),
                      ],
                    ),
                  ),
                ),
            transition: Transition.fade),
      ],
    );
  }
}
