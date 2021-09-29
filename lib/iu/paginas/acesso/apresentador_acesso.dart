abstract class ApresentadorAcesso {
  Stream<String> get emailComErroStream;
  Stream<String> get senhaComErroStream;
  Stream<String> get falhaAcessoStream;
  Stream<String> get navegaParaStream;
  Stream<bool> get camposSaoValidosStream;
  Stream<bool> get estaCarregandoStream;

  void validaEmail(String email);
  void validaSenha(String senha);
  Future<void> autenticacao();
  void liberaMemoria();
}
