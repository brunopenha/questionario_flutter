import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/iu/erros/erros.dart';
import 'package:questionario/iu/internacionalizacao/i18n/i18n.dart';
import 'package:questionario/iu/paginas/paginas.dart';

class ApresentadorInscricaoSimulado extends Mock implements ApresentadorInscricao {}

void main() {
  ApresentadorInscricao apresentador;
  StreamController<ErrosIU> nomeComErroController;
  StreamController<ErrosIU> emailComErroController;
  StreamController<ErrosIU> senhaComErroController;
  StreamController<ErrosIU> confirmacaoSenhaComErroController;

  void simulaStreams() {
    when(apresentador.nomeComErroStream).thenAnswer((_) => nomeComErroController.stream);
    when(apresentador.emailComErroStream).thenAnswer((_) => emailComErroController.stream);
    when(apresentador.senhaComErroStream).thenAnswer((_) => senhaComErroController.stream);
    when(apresentador.confirmaSenhaComErroStream).thenAnswer((_) => confirmacaoSenhaComErroController.stream);
  }

  void inicializaStreams() {
    nomeComErroController = StreamController<ErrosIU>();
    emailComErroController = StreamController<ErrosIU>();
    senhaComErroController = StreamController<ErrosIU>();
    confirmacaoSenhaComErroController = StreamController<ErrosIU>();
  }

  void encerraStreams() {
    nomeComErroController.close();
    emailComErroController.close();
    senhaComErroController.close();
    confirmacaoSenhaComErroController.close();
  }

  Future carregaPagina(WidgetTester widgetTester) async {
    apresentador = ApresentadorInscricaoSimulado();

    inicializaStreams();

    simulaStreams();

    final pagInscricao = GetMaterialApp(
      initialRoute: '/inscricao',
      getPages: [
        GetPage(name: '/inscricao', page: () => PaginaInscricao(apresentador)),
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

  testWidgets("Deveria validar os valores corretos dos campos", (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester); // É aqui que o componente é carregado para ser testado

    final textoNome = faker.person.name();
    await widgetTester.enterText(find.bySemanticsLabel(R.strings.nome), textoNome);
    verify(apresentador.validaNome(textoNome));

    final textoEmail = faker.internet.email();
    await widgetTester.enterText(find.bySemanticsLabel(R.strings.email), textoEmail);
    verify(apresentador.validaEmail(textoEmail));

    final textoSenha = faker.internet.password();
    await widgetTester.enterText(find.bySemanticsLabel(R.strings.senha), textoSenha);
    verify(apresentador.validaSenha(textoSenha));

    await widgetTester.enterText(find.bySemanticsLabel(R.strings.confirmacaoSenha), textoSenha);
    verify(apresentador.validaConfirmaSenha(textoSenha));
  });
}
