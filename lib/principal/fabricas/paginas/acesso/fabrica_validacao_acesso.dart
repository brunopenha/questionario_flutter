import '../../../../apresentacao/dependencias/validador.dart';
import '../../../../validacao/dependencias/dependencias.dart';
import '../../../../validacao/validadores/validadores.dart';

Validador criaValidadorAcesso() {
  return ValidacaoComposta(criaValidacoesAcesso());
}

List<ValidaCampos> criaValidacoesAcesso() {
  return [ValidaCamposObrigatorios('email'), ValidaCamposObrigatorios('senha'), ValidaEmail('email')];
}
