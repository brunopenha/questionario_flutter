abstract class ApresentadorIntroducao {
  Stream<String> get navegaParaTransmissor;
  Future<void> verificaContaAtual({int duracaoEmSegundos});
}
