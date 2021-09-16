import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/iu/paginas/paginas.dart';

class ApresentacaoAcessoSimulado extends Mock implements ApresentacaoAcesso {}

void main() {
  ApresentacaoAcesso apresentacao = ApresentacaoAcessoSimulado();

  Future carregaPagina(WidgetTester widgetTester) async {
    apresentacao = ApresentacaoAcessoSimulado();
    final pagAcesso = MaterialApp(
      home: PaginaAcesso(apresentacao),
    );

    await widgetTester.pumpWidget(
        pagAcesso); // É aqui que o componente é carregado para ser testado
  }

  testWidgets("Deveria carregar com o estado inicial",
      (WidgetTester widgetTester) async {
    await carregaPagina(
        widgetTester); // É aqui que o componente é carregado para ser testado

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

  testWidgets("Deveria validar os valores corretos dos campos",
      (WidgetTester widgetTester) async {
    await carregaPagina(
        widgetTester); // É aqui que o componente é carregado para ser testado

    final textoEmail = faker.internet.email();
    await widgetTester.enterText(find.bySemanticsLabel('Email'), textoEmail);
    verify(apresentacao.validaEmail(textoEmail));

    final textoSenha = faker.internet.password();
    await widgetTester.enterText(find.bySemanticsLabel('Senha'), textoSenha);
    verify(apresentacao.validaSenha(textoSenha));
  });
}
