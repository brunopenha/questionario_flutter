import 'package:questionario/principal/fabricas/cache/cache.dart';

import '../../../dados/casosuso/casosuso.dart';
import '../../../dominios/casosuso/casosuso.dart';
import '../fabricas.dart';

CarregaContaAtual criaCarregaContaAtualLocalmente() {
  return CarregaContaAtualLocalmente(obtemCacheArmazenadoComSeguranca: criaAdaptadorArmazenamentoLocal());
}
