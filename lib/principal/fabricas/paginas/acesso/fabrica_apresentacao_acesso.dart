import '../../../../apresentacao/apresentacao.dart';
import '../../fabricas.dart';

ApresentacaoAcessoTransmissor criaTransmissorAcesso() {
  return ApresentacaoAcessoTransmissor(
      autenticador: criaAuteticacaoRemota(), validador: criaValidadorAcesso());
}
