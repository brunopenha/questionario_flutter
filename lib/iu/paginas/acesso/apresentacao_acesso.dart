abstract class ApresentacaoAcesso {
  Stream<String> get emailComErroStream;
  Stream<String> get senhaComErroStream;
  Stream<String> get falhaAcessoStream;
  Stream<bool> get camposSaoValidosStream;
  Stream<bool> get paginaEstaCarregandoStream;

  void validaEmail(String email);
  void validaSenha(String senha);
  Future<void> autenticacao();
  void liberaMemoria();
}
