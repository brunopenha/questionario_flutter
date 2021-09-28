import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class PaginaIntroducao extends StatelessWidget {
  final ApresentadorIntroducao apresentador;

  PaginaIntroducao({@required this.apresentador});

  @override
  Widget build(BuildContext context) {
    apresentador.carregaContaAtual();
    return Scaffold(
        appBar: AppBar(
          title: Text('Bruno Penha'),
        ),
        body: Builder(
          builder: (context) {
            apresentador.navegaParaTransmissor.listen((pagina) {
              // Se a pagina existir...
              if (pagina?.isNotEmpty == true) {
                Get.offAllNamed(pagina); //... limpa a tela atual a chama a nova
              }
            });

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

abstract class ApresentadorIntroducao {
  Stream<String> get navegaParaTransmissor;
  Future<void> carregaContaAtual();
}

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
