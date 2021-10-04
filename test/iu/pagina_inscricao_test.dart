import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:questionario/iu/internacionalizacao/i18n/i18n.dart';
import 'package:questionario/iu/paginas/paginas.dart';

void main() {
  Future carregaPagina(WidgetTester widgetTester) async {
    final pagInscricao = GetMaterialApp(
      initialRoute: '/inscricao',
      getPages: [
        GetPage(name: '/inscricao', page: () => PaginaInscricao()),
      ],
    );

    await widgetTester.pumpWidget(pagInscricao); // É aqui que o componente é carregado para ser testado
  }

  testWidgets("Deveria carregar com o estado inicial", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    final nomeTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.nome), matching: find.byType(Text));
    expect(nomeTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Nome');

    final emailTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.email), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');

    final senhaTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.senha), matching: find.byType(Text));
    expect(senhaTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');

    final confirmacaoSenhaTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.confirmacaoSenha), matching: find.byType(Text));
    expect(confirmacaoSenhaTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Confirmar Senha');

    final botao = widgetTester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(botao.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
