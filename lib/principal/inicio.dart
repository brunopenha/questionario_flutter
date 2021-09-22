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
      initialRoute: '/acesso',
      getPages: [
        GetPage(name: '/acesso', page: criaPaginaAcesso),
      ],
    );
  }
}
