import 'package:questionario/principal/fabricas/fabricas.dart';
import 'package:questionario/validacao/validadores/validadores.dart';
import 'package:test/test.dart';

void main() {
  test('Deveria retornar os validadores corretos', () {
    final validacoes = criaValidacoesInscricao();

    expect(validacoes, [
      ValidadorCamposObrigatorios('nome'),
      ValidadorTamanhoMinimo(campo: 'nome', tamanhoCampo: 3),
      ValidadorCamposObrigatorios('email'),
      ValidadorEmail('email'),
      ValidadorCamposObrigatorios('senha'),
      ValidadorTamanhoMinimo(campo: 'senha', tamanhoCampo: 3),
      ValidadorCamposObrigatorios('confirmaSenha'),
      ValidadorComparaCampos(campo: 'confirmaSenha', campoParaComparar: 'senha')
    ]);
  });
}
