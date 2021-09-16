abstract class ApresentacaoAcesso {
  Stream get emailComErroStream;
  Stream get senhaComErroStream;

  void validaEmail(String email);

  void validaSenha(String senha);
}
