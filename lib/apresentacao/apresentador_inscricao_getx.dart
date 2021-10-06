import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../iu/erros/erros.dart';
import 'dependencias/dependencias.dart';

class ApresentacaoInscricaoGetx extends GetxController {
  final Validador validador;

  String _email;

  // Cria um Observer do get e esse observer é possível atribuir o Stream dentro dele
  final _emailComErro = Rx<ErrosIU>();
  final _camposSaoValidos = false.obs; // Nesse caso ele começa com um valor default

  // Toda vez que houver uma alteração nesse estado, algo deverá ser feito
  Stream<ErrosIU> get emailComErroStream => _emailComErro.stream;
  Stream<bool> get camposSaoValidosStream => _camposSaoValidos.stream;

  ApresentacaoInscricaoGetx({@required this.validador});

  ErrosIU _validaCampo({String campo, String valor}) {
    final erro = validador.valida(campo: campo, valor: valor);
    switch (erro) {
      case ErroValidacao.CAMPO_OBRIGATORIO:
        return ErrosIU.CAMPO_OBRIGATORIO;
      case ErroValidacao.DADO_INVALIDO:
        return ErrosIU.DADO_INVALIDO;
      case ErroValidacao.EMAIL_INVALIDO:
        return ErrosIU.EMAIL_INVALIDO;
      default:
        return null;
    }
  }

  void validaEmail(String textoEmail) {
    _emailComErro.value = _validaCampo(campo: 'email', valor: textoEmail);
    _validaFormulario();
  }

  void _validaFormulario() {
    // estaValido ele é um valor calculado caso algum dos campos não estejam validos
    _camposSaoValidos.value = false;
  }
}
