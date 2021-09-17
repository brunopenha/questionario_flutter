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
    String erro;

    for (final validacao in validadores.where((val) => val.campo == campo)) {
      erro = validacao.valida(valor);

      if (erro?.isNotEmpty == true) {
        break;
      }
    }
    return erro;
  }
}

class ValidaCamposSimulado extends Mock implements ValidaCampos {}

void main() {
  ValidacaoComposta sut;
  ValidaCamposSimulado validacao1;
  ValidaCamposSimulado validacao2;
  ValidaCamposSimulado validacao3;

  void validacao1Simulado(String erro) {
    when(validacao1.valida(any)).thenReturn(erro);
  }

  void validacao2Simulado(String erro) {
    when(validacao2.valida(any)).thenReturn(erro);
  }

  void validacao3Simulado(String erro) {
    when(validacao3.valida(any)).thenReturn(erro);
  }

  setUp(() {
    validacao1 = ValidaCamposSimulado();
    when(validacao1.campo).thenReturn('outro_campo');
    validacao1Simulado(null);

    validacao2 = ValidaCamposSimulado();
    when(validacao2.campo).thenReturn('qualquer_campo');
    validacao2Simulado(null);

    validacao3 = ValidaCamposSimulado();
    when(validacao3.campo).thenReturn('qualquer_campo');
    validacao3Simulado(null);

    sut = ValidacaoComposta([validacao1, validacao2, validacao3]);
  });

  test('retornar null se todos os validadores retorne null ou vazio', () {
    validacao2Simulado('');
    expect(sut.valida(campo: 'qualquer_campo', valor: 'qualquer_valor'), null);
  });

  test('Deveria Deveria retornar erro no primeiro campo validado', () {
    validacao1Simulado('erro 1');
    validacao2Simulado('erro 2');
    validacao3Simulado('erro 3');

    expect(sut.valida(campo: 'qualquer_campo', valor: 'qualquer_valor'), 'erro 2');
  });
}
