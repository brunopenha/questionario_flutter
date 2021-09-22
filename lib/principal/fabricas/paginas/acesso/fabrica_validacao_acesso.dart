import '../../../../apresentacao/dependencias/validador.dart';
import '../../../../validacao/validadores/validadores.dart';

Validador criaValidadorAcesso() {
  return ValidacaoComposta(
      [ValidaCamposObrigatorios('email'), ValidaCamposObrigatorios('senha'), ValidaEmail('email')]);
}
