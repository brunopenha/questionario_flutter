import 'package:meta/meta.dart';

import '../../apresentacao/dependencias/dependencias.dart';
import '../dependencias/dependencias.dart';

class ValidadorComposto implements Validador {
  final List<ValidadorCampos> validadores;

  ValidadorComposto(this.validadores);

  @override
  ErroValidacao valida({@required String campo, @required Map entrada}) {
    ErroValidacao erro;

    for (final validacao in validadores.where((val) => val.campo == campo)) {
      erro = validacao.valida(entrada);

      if (erro != null) {
        break;
      }
    }
    return erro;
  }
}
