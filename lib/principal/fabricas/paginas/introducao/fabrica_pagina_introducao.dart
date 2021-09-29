import 'package:flutter/material.dart';
import 'package:questionario/iu/paginas/introducao/introducao.dart';

import '../../../../iu/paginas/paginas.dart';
import '../../fabricas.dart';

Widget criaPaginaIntroducao() {
  return PaginaIntroducao(apresentador:criaApresentadorIntroducaoGetx());
}
