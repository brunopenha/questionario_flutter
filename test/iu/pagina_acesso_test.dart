import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/iu/paginas/paginas.dart';

class ApresentacaoAcessoSimulado extends Mock implements ApresentacaoAcesso {}

void main() {
  ApresentacaoAcesso apresentacao = ApresentacaoAcessoSimulado();
  StreamController<String> emailComErroController;
  StreamController<String> senhaComErroController;
  StreamController<bool> camposSaoValidosController;

  Future carregaPagina(WidgetTester widgetTester) async {
    apresentacao = ApresentacaoAcessoSimulado();

    emailComErroController = StreamController<String>();
    senhaComErroController = StreamController<String>();
    camposSaoValidosController = StreamController<bool>();

    when(apresentacao.emailComErroStream).thenAnswer((_) => emailComErroController.stream);
    when(apresentacao.senhaComErroStream).thenAnswer((_) => senhaComErroController.stream);
    when(apresentacao.camposSaoValidosStream).thenAnswer((_) => camposSaoValidosController.stream);

    final pagAcesso = MaterialApp(
      home: PaginaAcesso(apresentacao),
    );

    await widgetTester
        .pumpWidget(pagAcesso); // É aqui que o componente é carregado para ser testado
  }

  tearDown(() {
    emailComErroController.close();
    senhaComErroController.close();
    camposSaoValidosController.close();
  });

  testWidgets("Deveria carregar com o estado inicial", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    final emailTextChildren =
        find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');

    final senhaTextChildren =
        find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(senhaTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');

    final botao = widgetTester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(botao.onPressed, null);
  });

  testWidgets("Deveria validar os valores corretos dos campos", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    final textoEmail = faker.internet.email();
    await widgetTester.enterText(find.bySemanticsLabel('Email'), textoEmail);
    verify(apresentacao.validaEmail(textoEmail));

    final textoSenha = faker.internet.password();
    await widgetTester.enterText(find.bySemanticsLabel('Senha'), textoSenha);
    verify(apresentacao.validaSenha(textoSenha));
  });

  testWidgets("Deveria exibir um erro se o email for invalido", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add('qualquer erro'); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.text('qualquer erro'), findsOneWidget);
  });

  testWidgets("Não deveria exibir um erro se o email valido", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(null); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');
  });

  testWidgets("Não deveria exibir um erro se o email for valido",
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(''); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');
  });

  testWidgets("Deveria exibir um erro se a senha for invalida", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    senhaComErroController.add('qualquer erro'); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.text('qualquer erro'), findsOneWidget);
  });

  testWidgets("Não deveria exibir um erro se a senha for valida",
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    senhaComErroController.add(null); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');
  });

  testWidgets("Não deveria exibir um erro se a senha for valida",
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(''); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');
  });

  testWidgets("Habilita o botão se os campos forem validos", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    camposSaoValidosController.add(true); // Emito um evento qualquer
    await widgetTester.pump();

    final botao = widgetTester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(botao.onPressed, isNotNull);
  });
}
