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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

abstract class ApresentadorIntroducao {
  Future<void> carregaContaAtual();
}

class ApresentadorIntroducaoSimulado extends Mock implements ApresentadorIntroducao {}

void main() {
  ApresentadorIntroducaoSimulado apresentador;

  Future carregaPagina(WidgetTester widgetTester) async {
    apresentador = ApresentadorIntroducaoSimulado();
    await widgetTester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => PaginaIntroducao(apresentador: apresentador))],
    ));
  }

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
}
