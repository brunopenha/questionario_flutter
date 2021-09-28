import 'package:questionario/principal/fabricas/cache/cache.dart';

import '../../../dados/casosuso/casosuso.dart';
import '../../../dominios/casosuso/casosuso.dart';
import '../fabricas.dart';

SalvaContaAtual criaSalvaContaAtualLocalmente() {
  return SalvaContaAtualLocalmente(salvaArmazenamentoCacheComSeguranca: criaAdaptadorArmazenamentoLocal());
}
