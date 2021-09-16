abstract class ApresentacaoAcesso {
  Stream get emailComErroStream;
  Stream get senhaComErroStream;
  Stream get camposSaoValidosStream;

  void validaEmail(String email);

  void validaSenha(String senha);
}
