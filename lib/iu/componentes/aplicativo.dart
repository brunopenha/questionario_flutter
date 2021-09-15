import 'package:flutter/material.dart';

import '../telas/telas.dart';

class Aplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final corPrimaria = Color.fromRGBO(136, 14, 79, 1);
    final corPrimariaEscura = Color.fromRGBO(96, 0, 39, 1);
    final corPrimariaClara = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: 'Questionário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: corPrimariaClara,
        primaryColorDark: corPrimariaEscura,
        primaryColorLight: corPrimariaClara,
        accentColor: corPrimaria,
        backgroundColor: Colors.white,
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: corPrimariaEscura)),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: corPrimariaClara)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: corPrimaria)),
          alignLabelWithHint: true,
        ),
        buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: corPrimaria,
            ),
            buttonColor: corPrimaria,
            splashColor: corPrimariaClara,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
      home: PaginaAcesso(),
    );
  }
}
