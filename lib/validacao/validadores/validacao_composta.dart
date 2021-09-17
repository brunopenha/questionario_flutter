import 'package:meta/meta.dart';

import '../../apresentacao/dependencias/dependencias.dart';
import '../dependencias/dependencias.dart';

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
