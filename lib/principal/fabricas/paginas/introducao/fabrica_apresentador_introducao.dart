import 'package:questionario/iu/paginas/paginas.dart';

import '../../../../apresentacao/apresentacao.dart';
import '../../fabricas.dart';

ApresentadorIntroducao criaApresentadorIntroducaoGetx() {
  return ApresentadorIntroducaoGetx(carregaContaAtual: criaCarregaContaAtualLocalmente());
}
