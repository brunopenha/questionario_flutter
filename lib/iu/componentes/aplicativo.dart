import 'package:flutter/material.dart';

import '../telas/telas.dart';

class Aplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionário',
      debugShowCheckedModeBanner: false,
      home: PaginaAcesso(),
    );
  }
}
