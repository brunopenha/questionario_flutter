import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/iu/paginas/introducao/introducao.dart';

class ApresentadorIntroducaoSimulado extends Mock implements ApresentadorIntroducao {}

void main() {
  ApresentadorIntroducaoSimulado apresentador;
  StreamController<String> navegaParaControlador;

  Future carregaPagina(WidgetTester widgetTester) async {
    apresentador = ApresentadorIntroducaoSimulado();
    navegaParaControlador = StreamController<String>();
    when(apresentador.navegaParaTransmissor).thenAnswer((_) => navegaParaControlador.stream);

    await widgetTester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => PaginaIntroducao(apresentador: apresentador)),
        GetPage(name: '/qualquer_rota', page: () => Scaffold(body: Text('pagina teste')))
      ],
    ));
  }

  tearDown(() {
    navegaParaControlador.close();
  });

  testWidgets('Deveria apresentar um spinner quando a pagina for carregada',
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester);

    // Uma vez que foi carregado o componente, esperamos que tenha um Spinner na tela
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Deveria chamar carregaContaAtual quando a pagina for carregada',
      (WidgetTester widgetTester) async {
    // Carregamos a tela
    await carregaPagina(widgetTester);

    verify(apresentador.carregaContaAtual()).called(1);
  });

  testWidgets('Deveria mudar de pagina', (WidgetTester widgetTester) async {
    // Carregamos a tela
    await carregaPagina(widgetTester);

    navegaParaControlador.add('/qualquer_rota');
    await widgetTester.pumpAndSettle();

    expect(Get.currentRoute,
        '/qualquer_rota'); // Tenho que garantir que a tela está ouvindo a esse evento, reagindo ao mudar de rota (de tela)
    expect(find.text('pagina teste'), findsOneWidget);
  });

  testWidgets('Não deveria mudar a pagina', (WidgetTester widgetTester) async {
    // Carregamos a tela
    await carregaPagina(widgetTester);

    navegaParaControlador.add('');
    await widgetTester.pump();
    expect(Get.currentRoute, '/');

    navegaParaControlador.add(null);
    await widgetTester.pump();
    expect(Get.currentRoute, '/');
  });
}
