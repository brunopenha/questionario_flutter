import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/iu/erros/erros.dart';
import 'package:questionario/iu/internacionalizacao/i18n/i18n.dart';
import 'package:questionario/iu/paginas/paginas.dart';

class ApresentacaoAcessoSimulado extends Mock implements ApresentadorAcesso {}

ApresentadorAcesso apresentador = ApresentacaoAcessoSimulado();
StreamController<ErrosIU> emailComErroController;
StreamController<ErrosIU> senhaComErroController;
StreamController<ErrosIU> falhaAcessoController;
StreamController<String> navegaParaControlador;
StreamController<bool> camposSaoValidosController;
StreamController<bool> paginaEstaCarregandoController;

Future carregaPagina(WidgetTester widgetTester) async {
  apresentador = ApresentacaoAcessoSimulado();

  inicializaStreams();

  simulaStreams();

  final pagAcesso = GetMaterialApp(
    initialRoute: '/acesso',
    getPages: [
      GetPage(name: '/acesso', page: () => PaginaAcesso(apresentador)),
      GetPage(
          name: '/qualquer_rota',
          page: () => Scaffold(
                body: Text('Pagina Falsa'),
              ))
    ],
  );

  await widgetTester.pumpWidget(pagAcesso); // É aqui que o componente é carregado para ser testado
}

void simulaStreams() {
  when(apresentador.emailComErroStream).thenAnswer((_) => emailComErroController.stream);
  when(apresentador.senhaComErroStream).thenAnswer((_) => senhaComErroController.stream);
  when(apresentador.falhaAcessoStream).thenAnswer((_) => falhaAcessoController.stream);
  when(apresentador.navegaParaStream).thenAnswer((_) => navegaParaControlador.stream);
  when(apresentador.camposSaoValidosStream).thenAnswer((_) => camposSaoValidosController.stream);
  when(apresentador.estaCarregandoStream).thenAnswer((_) => paginaEstaCarregandoController.stream);
}

void inicializaStreams() {
  emailComErroController = StreamController<ErrosIU>();
  senhaComErroController = StreamController<ErrosIU>();
  falhaAcessoController = StreamController<ErrosIU>();
  navegaParaControlador = StreamController<String>();
  camposSaoValidosController = StreamController<bool>();
  paginaEstaCarregandoController = StreamController<bool>();
}

void encerraStreams() {
  emailComErroController.close();
  senhaComErroController.close();
  falhaAcessoController.close();
  navegaParaControlador.close();
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
        find.descendant(of: find.bySemanticsLabel(R.strings.email), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');

    final senhaTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.senha), matching: find.byType(Text));
    expect(senhaTextChildren, findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');

    final botao = widgetTester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(botao.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets("Deveria validar os valores corretos dos campos", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    final textoEmail = faker.internet.email();
    await widgetTester.enterText(find.bySemanticsLabel(R.strings.email), textoEmail);
    verify(apresentador.validaEmail(textoEmail));

    final textoSenha = faker.internet.password();
    await widgetTester.enterText(find.bySemanticsLabel(R.strings.senha), textoSenha);
    verify(apresentador.validaSenha(textoSenha));
  });

  testWidgets("Deveria exibir um erro se o email for invalido", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(ErrosIU.EMAIL_INVALIDO); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.text(R.strings.emailInvalido), findsOneWidget);
  });

  testWidgets("Deveria exibir um erro se o email for vazio", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(ErrosIU.CAMPO_OBRIGATORIO); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.text(R.strings.campoObrigatorio), findsOneWidget);
  });

  testWidgets("Não deveria exibir um erro se o email valido", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    emailComErroController.add(null); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel(R.strings.email), matching: find.byType(Text)),
        findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');
  });

  testWidgets("Não deveria exibir um erro se o email for valido", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    expect(find.descendant(of: find.bySemanticsLabel(R.strings.email), matching: find.byType(Text)),
        findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Email');
  });

  testWidgets("Deveria exibir um erro se a senha for vazia", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    senhaComErroController.add(ErrosIU.CAMPO_OBRIGATORIO); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.text(R.strings.campoObrigatorio), findsOneWidget);
  });

  testWidgets("Não deveria exibir um erro se a senha for valida", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    senhaComErroController.add(null); // Emito um evento qualquer
    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel(R.strings.senha), matching: find.byType(Text)),
        findsOneWidget,
        reason: 'O teste irá passar se encontrar apenas um componente de Text no campo Senha');
  });

  testWidgets("Não deveria exibir um erro se a senha for valida", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    await widgetTester.pump();

    expect(find.descendant(of: find.bySemanticsLabel(R.strings.senha), matching: find.byType(Text)),
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

    final botao = find.byType(RaisedButton);
    await widgetTester.ensureVisible(botao); // garante que o botao está visivel antes de testar o clique nele

    await widgetTester.tap(botao); // cliquei no botão
    await widgetTester.pump(); // recarrego a tela

    verify(apresentador.autenticacao()).called(1);
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

    falhaAcessoController.add(ErrosIU.CREDENCIAIS_INVALIDAS); // apresento o motivo da falha
    await widgetTester.pump(); // recarrego a tela

    expect(find.text(R.strings.credenciaisInvalidas), findsOneWidget);
  });

  testWidgets("Deveria apresentar mensagem de erro se a autenticacao lançar uma exceão",
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    falhaAcessoController.add(ErrosIU.INESPERADO); // apresento o motivo da falha
    await widgetTester.pump(); // recarrego a tela

    expect(find.text(R.strings.erroInesperado), findsOneWidget);
  });

  testWidgets("Deveria mudar de pagina", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    navegaParaControlador
        .add('/qualquer_rota'); // o valor que eu emitir aqui tem que ser o valor que sera recebido na tela
    await widgetTester.pumpAndSettle(); // A tela demora um pouco aparecer por isso o pumpAndSettle

    expect(Get.currentRoute,
        '/qualquer_rota'); // Verifico que o nome da pagina que for recebida no Streamer tem que ser o mesmo nome do destino
    expect(find.text('Pagina Falsa'), findsOneWidget);
  });

  testWidgets('Não deveria mudar a pagina', (WidgetTester widgetTester) async {
    // Carregamos a tela
    await carregaPagina(widgetTester);

    navegaParaControlador.add('');
    await widgetTester.pump();
    expect(Get.currentRoute, '/acesso');

    navegaParaControlador.add(null);
    await widgetTester.pump();
    expect(Get.currentRoute, '/acesso');
  });
}
