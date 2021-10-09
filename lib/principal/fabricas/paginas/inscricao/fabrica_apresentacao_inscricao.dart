import 'package:questionario/iu/paginas/paginas.dart';

import '../../../../apresentacao/apresentacao.dart';
import '../../fabricas.dart';

ApresentadorAcesso criaApresentadorAcessoGetx() {
  return ApresentacaoAcessoGetx(
      autenticador: criaAuteticacaoRemota(),
      validador: criaValidadorAcesso(),
      salvaContaAtual: criaSalvaContaAtualLocalmente());
}
