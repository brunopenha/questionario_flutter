import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/apresentacao/dependencias/dependencias.dart';
import 'package:questionario/validacao/dependencias/dependencias.dart';

class ValidacaoComposta implements Validador {
  final List<ValidaCampos> validadores;

  ValidacaoComposta(this.validadores);

  @override
  String valida({@required String campo, @required String valor}) {
    return null;
  }
}

class ValidaCamposSimulado extends Mock implements ValidaCampos {}

void main() {
  test('Deveria retornar null se todos os validadores retorne null ou vazio', () {
    final validacao1 = ValidaCamposSimulado();
    when(validacao1.campo).thenReturn('qualquer_campo');
    when(validacao1.valida(any)).thenReturn(null);

    final validacao2 = ValidaCamposSimulado();
    when(validacao2.campo).thenReturn('qualquer_campo');
    when(validacao2.valida(any)).thenReturn('');

    final sut = ValidacaoComposta([validacao1, validacao2]);

    final erro = sut.valida(campo: 'qualquer_campo', valor: 'qualquer_valor');

    expect(erro, null);
  });
}
