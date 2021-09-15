import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questionario/iu/telas/telas.dart';

void main() {
  testWidgets("Deveria carregar com o estado inicial",
      (WidgetTester widgetTester) async {
    final pagAcesso = MaterialApp(
      home: PaginaAcesso(),
    );

    await widgetTester.pumpWidget(
        pagAcesso); // É aqui que o componente é carregado para ser testado

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason:
            'O teste irá passar se encontrar apenas um componente de Text no campo Email');

    final senhaTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(senhaTextChildren, findsOneWidget,
        reason:
            'O teste irá passar se encontrar apenas um componente de Text no campo Senha');

    final botao = widgetTester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(botao.onPressed, null);
  });
}
