import 'package:meta/meta.dart';

import '../../apresentacao/apresentacao.dart';
import '../dependencias/dependencias.dart';

class ValidadorTamanhoMinimo implements ValidadorCampos {
  final String campo;
  final int tamanho;

  ValidadorTamanhoMinimo({@required this.campo, @required this.tamanho});

  @override
  ErroValidacao valida(String valor) {
    return valor != null && valor.length >= tamanho ? null : ErroValidacao.DADO_INVALIDO;
  }
}
