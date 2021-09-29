import 'package:questionario/iu/paginas/paginas.dart';

import '../../../../apresentacao/apresentacao.dart';
import '../../fabricas.dart';

ApresentadorAcesso criaApresentadorAcessoTransmissor() {
  return ApresentacaoAcessoTransmissor(
      autenticador: criaAuteticacaoRemota(), validador: criaValidadorAcesso());
}

ApresentadorAcesso criaApresentadorAcessoGetx() {
  return ApresentacaoAcessoGetx(
      autenticador: criaAuteticacaoRemota(),
      validador: criaValidadorAcesso(),
      salvaContaAtual: criaSalvaContaAtualLocalmente());
}
