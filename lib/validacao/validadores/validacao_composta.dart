import 'package:meta/meta.dart';

import '../../apresentacao/dependencias/dependencias.dart';
import '../dependencias/dependencias.dart';

class ValidacaoComposta implements Validador {
  final List<ValidaCampos> validadores;

  ValidacaoComposta(this.validadores);

  @override
  ErroValidacao valida({@required String campo, @required String valor}) {
    ErroValidacao erro;

    for (final validacao in validadores.where((val) => val.campo == campo)) {
      erro = validacao.valida(valor);

      if (erro != null) {
        break;
      }
    }
    return erro;
  }
}
