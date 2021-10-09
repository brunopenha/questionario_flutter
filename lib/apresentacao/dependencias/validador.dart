import 'package:meta/meta.dart';

abstract class Validador {
  ErroValidacao valida({@required String campo, @required Map entrada});
}

enum ErroValidacao { CAMPO_OBRIGATORIO, DADO_INVALIDO, EMAIL_INVALIDO }
