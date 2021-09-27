import 'package:questionario/iu/paginas/paginas.dart';

import '../../../../apresentacao/apresentacao.dart';
import '../../fabricas.dart';

ApresentacaoAcesso criaTransmissorApresentadorAcesso() {
  return ApresentacaoAcessoTransmissor(
      autenticador: criaAuteticacaoRemota(), validador: criaValidadorAcesso());
}

ApresentacaoAcesso criaGetxApresentadorAcesso() {
  return ApresentacaoAcessoGex(autenticador: criaAuteticacaoRemota(), validador: criaValidadorAcesso());
}
