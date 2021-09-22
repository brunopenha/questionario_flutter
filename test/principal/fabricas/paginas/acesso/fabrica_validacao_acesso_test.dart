import 'package:questionario/principal/fabricas/fabricas.dart';
import 'package:questionario/validacao/validadores/validadores.dart';
import 'package:test/test.dart';

void main() {
  test('Deveria retornar os validadores corretos', () {
    final validacoes = criaValidacoesAcesso();

    expect(validacoes,
        [ValidaCamposObrigatorios('email'), ValidaCamposObrigatorios('senha'), ValidaEmail('email')]);
  });
}
