import '../../../iu/erros/erros.dart';

abstract class ApresentadorAcesso {
  Stream<ErrosIU> get emailComErroStream;
  Stream<ErrosIU> get senhaComErroStream;
  Stream<ErrosIU> get falhaAcessoStream;
  Stream<String> get navegaParaStream;
  Stream<bool> get camposSaoValidosStream;
  Stream<bool> get paginaEstaCarregandoStream;

  void validaEmail(String email);
  void validaSenha(String senha);
  Future<void> autenticacao();
  void liberaMemoria();
}
