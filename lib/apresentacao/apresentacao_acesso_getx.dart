import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:questionario/iu/paginas/paginas.dart';

import '../dominios/casosuso/casosuso.dart';
import '../dominios/erros/erros.dart';
import 'dependencias/dependencias.dart';

class ApresentacaoAcessoGex extends GetxController implements ApresentacaoAcesso {
  final Validador validador;
  final Autenticador autenticador;
  final SalvaContaAtual salvaContaAtual;

  String _email;
  String _senha;

  // Cria um Observer do get e esse observer é possível atribuir o Stream dentro dele
  var _emailComErro = RxString();
  var _senhaComErro = RxString();
  var _falhaAcesso = RxString();
  var _navegaPara = RxString();
  var _camposSaoValidos = false.obs; // Nesse caso ele começa com um valor default
  var _estaCarregando = false.obs;

  ApresentacaoAcessoGex(
      {@required this.validador, @required this.autenticador, @required this.salvaContaAtual});

  // Toda vez que houver uma alteração nesse estado, algo deverá ser feito
  Stream<String> get emailComErroStream => _emailComErro.stream;

  Stream<String> get senhaComErroStream => _senhaComErro.stream;
  Stream<String> get falhaAcessoStream => _falhaAcesso.stream;
  Stream<String> get navegaParaStream => _navegaPara.stream;

  Stream<bool> get camposSaoValidosStream => _camposSaoValidos.stream;
  Stream<bool> get estaCarregandoStream => _estaCarregando.stream;

  void validaEmail(String textoEmail) {
    _email = textoEmail;
    _emailComErro.value = validador.valida(campo: 'email', valor: textoEmail);
    _validaFormulario();
  }

  void validaSenha(String textoSenha) {
    _senha = textoSenha;
    _senhaComErro.value = validador.valida(campo: 'senha', valor: textoSenha);
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
      _falhaAcesso.value = erro.descricao;
    } finally {
      _estaCarregando.value = false;
    }
  }

  void liberaMemoria() {}
}
