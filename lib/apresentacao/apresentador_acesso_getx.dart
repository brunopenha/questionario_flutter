import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../dominios/casosuso/casosuso.dart';
import '../dominios/erros/erros.dart';
import '../iu/erros/erros.dart';
import '../iu/paginas/paginas.dart';
import 'dependencias/dependencias.dart';

class ApresentacaoAcessoGetx extends GetxController implements ApresentadorAcesso {
  final Validador validador;
  final Autenticador autenticador;
  final SalvaContaAtual salvaContaAtual;

  String _email;
  String _senha;

  // Cria um Observer do get e esse observer é possível atribuir o Stream dentro dele
  var _emailComErro = Rx<ErrosIU>();
  var _senhaComErro = Rx<ErrosIU>();
  var _falhaAcesso = Rx<ErrosIU>();
  var _navegaPara = RxString();
  var _camposSaoValidos = false.obs; // Nesse caso ele começa com um valor default
  var _estaCarregando = false.obs;

  ApresentacaoAcessoGetx(
      {@required this.validador, @required this.autenticador, @required this.salvaContaAtual});

  // Toda vez que houver uma alteração nesse estado, algo deverá ser feito
  Stream<ErrosIU> get emailComErroStream => _emailComErro.stream;
  Stream<ErrosIU> get senhaComErroStream => _senhaComErro.stream;
  Stream<ErrosIU> get falhaAcessoStream => _falhaAcesso.stream;
  Stream<String> get navegaParaStream => _navegaPara.stream;

  Stream<bool> get camposSaoValidosStream => _camposSaoValidos.stream;
  Stream<bool> get paginaEstaCarregandoStream => _estaCarregando.stream;

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
    _email = textoEmail;
    _emailComErro.value = _validaCampo(campo: 'email', valor: textoEmail);
    _validaFormulario();
  }

  void validaSenha(String textoSenha) {
    _senha = textoSenha;
    _senhaComErro.value = _validaCampo(campo: 'senha', valor: textoSenha);
    _validaFormulario();
  }

  void _validaFormulario() {
    // estaValido ele é um valor calculado caso algum dos campos não estejam validos
    _camposSaoValidos.value =
        _emailComErro.value == null && _senhaComErro.value == null && _email != null && _senha != null;
  }

  Future<void> autenticacao() async {
    _estaCarregando.value = true;

    try {
      final conta = await autenticador.autoriza(ParametrosAutenticador(email: _email, senha: _senha));
      await salvaContaAtual.salva(conta);
      _navegaPara.value = '/pesquisas';
    } on ErrosDominio catch (erro) {
      switch (erro) {
        case ErrosDominio.credenciaisInvalidas:
          _falhaAcesso.value = ErrosIU.CREDENCIAIS_INVALIDAS;
          break;
        default:
          _falhaAcesso.value = ErrosIU.INESPERADO;
      }
    } finally {
      _estaCarregando.value = false;
    }
  }

  void liberaMemoria() {}

  @override
  void vaParaInscricao() {
    _navegaPara.value = '/pesquisas';
  }
}
