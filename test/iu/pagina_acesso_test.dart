import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/iu/paginas/paginas.dart';

class ApresentacaoAcessoSimulado extends Mock implements ApresentacaoAcesso {}

ApresentacaoAcesso apresentacao = ApresentacaoAcessoSimulado();
StreamController<String> emailComErroController;
StreamController<String> senhaComErroController;
StreamController<String> falhaAcessoController;
StreamController<bool> camposSaoValidosController;
StreamController<bool> paginaEstaCarregandoController;

Future carregaPagina(WidgetTester widgetTester) async {
  apresentacao = ApresentacaoAcessoSimulado();

  inicializaStreams();

  simulaStreams();

  final pagAcesso = MaterialApp(
    home: PaginaAcesso(apresentacao),
  );

  await widgetTester.pumpWidget(pagAcesso); // É aqui que o componente é carregado para ser testado
}

void simulaStreams() {
  when(apresentacao.emailComErroStream).thenAnswer((_) => emailComErroController.stream);
  when(apresentacao.senhaComErroStream).thenAnswer((_) => senhaComErroController.stream);
  when(apresentacao.falhaAcessoStream).thenAnswer((_) => falhaAcessoController.stream);
  when(apresentacao.camposSaoValidosStream).thenAnswer((_) => camposSaoValidosController.stream);
  when(apresentacao.paginaEstaCarregandoStream).thenAnswer((_) => paginaEstaCarregandoController.stream);
}

void inicializaStreams() {
  emailComErroController = StreamController<String>();
  senhaComErroController = StreamController<String>();
  falhaAcessoController = StreamController<String>();
  camposSaoValidosController = StreamController<bool>();
  paginaEstaCarregandoController = StreamController<bool>();
}

void encerraStreams() {
  emailComErroController.close();
  senhaComErroController.close();
  falhaAcessoController.close();
  camposSaoValidosController.close();
  paginaEstaCarregandoController.close();
}

void main() {
  tearDown(() {
    encerraStreams();
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

    expect(find.byType(CircularProgressIndicator), findsNothing);
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

    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');
  });

  testWidgets("Não deveria exibir um erro se o email for valido", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(''); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text)), findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');
  });

  testWidgets("Deveria exibir um erro se a senha for invalida", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    senhaComErroController.add('qualquer erro'); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.text('qualquer erro'), findsOneWidget);
  });

  testWidgets("Não deveria exibir um erro se a senha for valida", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    senhaComErroController.add(null); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)), findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');
  });

  testWidgets("Não deveria exibir um erro se a senha for valida", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(''); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)), findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');
  });

  testWidgets("Habilita o botão se os campos forem validos", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    camposSaoValidosController.add(true); // Emito um evento qualquer
    await widgetTester.pump();

    final botao = widgetTester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(botao.onPressed, isNotNull);
  });

  testWidgets("Desabilita o botão se os campos forem invalidos", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    camposSaoValidosController.add(false); // Emito um evento qualquer
    await widgetTester.pump();

    final botao = widgetTester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(botao.onPressed, null);
  });

  testWidgets("Deveria chamar a autenticacao quando o formulario for enviado",
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    camposSaoValidosController.add(true); // habilito o botão
    await widgetTester.pump(); // recarrego a tela

    await widgetTester.tap(find.byType(RaisedButton)); // cliquei no botão
    await widgetTester.pump(); // recarrego a tela

    verify(apresentacao.autenticador()).called(1);
  });

  testWidgets("Deveria aprensentar a mensagem Carregando", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    paginaEstaCarregandoController.add(true); // apresento o carregando...
    await widgetTester.pump(); // recarrego a tela

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Deveria esconder a mensagem Carregando", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    paginaEstaCarregandoController.add(true); // apresento o carregando...
    await widgetTester.pump(); // recarrego a tela
    paginaEstaCarregandoController.add(false); // escondo o carregando...
    await widgetTester.pump(); // recarrego a tela

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets("Deveria apresentar mensagem de erro se a autenticacao falhar",
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    falhaAcessoController.add('Erro no Acesso'); // apresento o motivo da falha
    await widgetTester.pump(); // recarrego a tela

    expect(find.text('Erro no Acesso'), findsOneWidget);
  });

  testWidgets("Deveria fechar os objetos Streams quando a tela fechar - prevenão de vazamento de memória",
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    // Aqui é que garanto que será chamado o dispose
    addTearDown(() => {
          // Quando esse tearDown for chamado, a pagina já deve ser "destruida"
          verify(apresentacao.liberaMemoria())
        });
  });
}
