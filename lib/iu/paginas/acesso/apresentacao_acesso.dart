abstract class ApresentacaoAcesso {
  Stream<String> get emailComErroStream;
  Stream<String> get senhaComErroStream;
  Stream<String> get camposSaoValidosStream;
  Stream<bool> get paginaEstaCarregandoStream;
  Stream<bool> get falhaAcessoStream;

  void validaEmail(String email);
  void validaSenha(String senha);
  void autenticador();
  void liberaMemoria();
}
