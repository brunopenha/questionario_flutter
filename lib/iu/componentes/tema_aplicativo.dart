import 'package:flutter/material.dart';

ThemeData aplicaTemaNoAplicativo() {
  final corPrimaria = Color.fromRGBO(136, 14, 79, 1);
  final corPrimariaEscura = Color.fromRGBO(96, 0, 39, 1);
  final corPrimariaClara = Color.fromRGBO(188, 71, 123, 1);

  return ThemeData(
    primaryColor: corPrimariaClara,
    primaryColorDark: corPrimariaEscura,
    primaryColorLight: corPrimariaClara,
    accentColor: corPrimaria,
    backgroundColor: Colors.white,
    textTheme:
        TextTheme(headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: corPrimariaEscura)),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: corPrimariaClara)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: corPrimaria)),
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
  );
}
