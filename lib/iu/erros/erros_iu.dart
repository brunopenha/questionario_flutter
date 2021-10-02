import '../internacionalizacao/i18n/i18n.dart';

enum ErrosIU { INESPERADO, CREDENCIAIS_INVALIDAS, CAMPO_OBRIGATORIO, DADO_INVALIDO, EMAIL_INVALIDO }

extension ExtensaoErrosDominio on ErrosIU {
  String get descricao {
    switch (this) {
      case ErrosIU.CREDENCIAIS_INVALIDAS:
        return R.strings.credenciaisInvalidas;
      case ErrosIU.CAMPO_OBRIGATORIO:
        return R.strings.campoObrigatorio;
      case ErrosIU.DADO_INVALIDO:
        return R.strings.dadoInvalido;
      case ErrosIU.EMAIL_INVALIDO:
        return R.strings.emailInvalido;
      default:
        return R.strings.erroInesperado;
    }
  }
}
