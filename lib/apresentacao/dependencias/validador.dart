import 'package:meta/meta.dart';

abstract class Validador {
  ErroValidacao valida({@required String campo, @required String valor});
}

enum ErroValidacao { CAMPO_OBRIGATORIO, DADO_INVALIDO, EMAIL_INVALIDO }
