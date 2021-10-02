import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/validacao/dependencias/dependencias.dart';
import 'package:questionario/validacao/validadores/validadores.dart';

class ValidaCamposSimulado extends Mock implements ValidaCampos {}

void main() {
  ValidacaoComposta sut;
  ValidaCamposSimulado validacao1;
  ValidaCamposSimulado validacao2;
  ValidaCamposSimulado validacao3;

  void validacao1Simulado(ErroValidacao erro) {
    when(validacao1.valida(any)).thenReturn(erro);
  }

  void validacao2Simulado(ErroValidacao erro) {
    when(validacao2.valida(any)).thenReturn(erro);
  }

  void validacao3Simulado(ErroValidacao erro) {
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
    expect(sut.valida(campo: 'qualquer_campo', valor: 'qualquer_valor'), null);
  });

  test('Deveria Deveria retornar erro no primeiro campo validado', () {
    validacao1Simulado(ErroValidacao.CAMPO_OBRIGATORIO);
    validacao2Simulado(ErroValidacao.CAMPO_OBRIGATORIO);
    validacao3Simulado(ErroValidacao.DADO_INVALIDO);

    expect(
        sut.valida(campo: 'qualquer_campo', valor: 'qualquer_valor'), ErroValidacao.CAMPO_OBRIGATORIO); // 2
  });
}
