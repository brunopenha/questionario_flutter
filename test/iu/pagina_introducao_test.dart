import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class PaginaIntroducao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

void main() {
  Future carregaPagina(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => PaginaIntroducao())],
    ));
  }

  testWidgets('Deveria apresentar um spinner quando a pagina for carregada',
      (WidgetTester widgetTester) async {
    await carregaPagina(widgetTester);

    // Uma vez que foi carregado o componente, esperamos que tenha um Spinner na tela
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
