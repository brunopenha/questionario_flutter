import '../../../iu/erros/erros.dart';

abstract class ApresentadorInscricao {
  Stream<ErrosIU> get nomeComErroStream;
  Stream<ErrosIU> get emailComErroStream;
  Stream<ErrosIU> get senhaComErroStream;
  Stream<ErrosIU> get confirmaSenhaComErroStream;

  void validaNome(String nome);
  void validaEmail(String email);
  void validaSenha(String senha);
  void validaConfirmaSenha(String confirmaSenha);
}
