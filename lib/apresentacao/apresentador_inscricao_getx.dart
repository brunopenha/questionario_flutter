import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../dominios/casosuso/casosuso.dart';
import '../iu/erros/erros.dart';
import 'dependencias/dependencias.dart';

class ApresentacaoInscricaoGetx extends GetxController {
  final Validador validador;
  final AdicionaConta adicionaConta;

  String _email;
  String _nome;
  String _senha;
  String _confirmaSenha;

  // Cria um Observer do get e esse observer é possível atribuir o Stream dentro dele
  final _emailComErro = Rx<ErrosIU>();
  final _nomeComErro = Rx<ErrosIU>();
  final _senhaComErro = Rx<ErrosIU>();
  final _confirmaSenhaComErro = Rx<ErrosIU>();
  final _camposSaoValidos = false.obs; // Nesse caso ele começa com um valor default

  // Toda vez que houver uma alteração nesse estado, algo deverá ser feito
  Stream<ErrosIU> get emailComErroStream => _emailComErro.stream;
  Stream<ErrosIU> get nomeComErroStream => _nomeComErro.stream;
  Stream<ErrosIU> get senhaComErroStream => _senhaComErro.stream;
  Stream<ErrosIU> get confirmaSenhaComErroStream => _confirmaSenhaComErro.stream;
  Stream<bool> get camposSaoValidosStream => _camposSaoValidos.stream;

  ApresentacaoInscricaoGetx({@required this.validador, @required this.adicionaConta});

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

  void validaNome(String textoNome) {
    _nome = textoNome;
    _nomeComErro.value = _validaCampo(campo: 'nome', valor: textoNome);
    _validaFormulario();
  }

  void validaSenha(String textoSenha) {
    _senha = textoSenha;
    _senhaComErro.value = _validaCampo(campo: 'senha', valor: textoSenha);
    _validaFormulario();
  }

  void validaConfirmaSenha(String textoConfirmaSenha) {
    _confirmaSenha = textoConfirmaSenha;
    _confirmaSenhaComErro.value = _validaCampo(campo: 'confirmaSenha', valor: textoConfirmaSenha);
    _validaFormulario();
  }

  void _validaFormulario() {
    // estaValido ele é um valor calculado caso algum dos campos não estejam validos
    _camposSaoValidos.value = _nomeComErro.value == null &&
        _emailComErro.value == null &&
        _senhaComErro.value == null &&
        _confirmaSenhaComErro.value == null &&
        _nome != null &&
        _email != null &&
        _confirmaSenha != null &&
        _senha != null;
  }

  Future<void> adiciona() async {
    await adicionaConta.adicionaConta(
        ParametrosAdicionaConta(nome: _nome, email: _email, senha: _senha, confirmaSenha: _confirmaSenha));
  }
}
