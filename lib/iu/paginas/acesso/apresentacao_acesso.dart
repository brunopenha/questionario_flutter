abstract class ApresentacaoAcesso {
  Stream get emailComErroStream;
  Stream get senhaComErroStream;
  Stream get camposSaoValidosStream;
  Stream get paginaEstaCarregandoStream;
  Stream get falhaAcessoStream;

  void validaEmail(String email);
  void validaSenha(String senha);
  void autenticador();
  void liberaMemoria();
}
