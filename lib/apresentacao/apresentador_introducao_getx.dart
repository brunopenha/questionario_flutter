import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../dominios/casosuso/casosuso.dart';
import '../iu/paginas/introducao/introducao.dart';

class ApresentadorIntroducaoGetx implements ApresentadorIntroducao {
  final CarregaContaAtual carregaContaAtual;

  var _navegaPara = RxString();

  ApresentadorIntroducaoGetx({@required this.carregaContaAtual});

  Future<void> verificaContaAtual({int duracaoEmSegundos = 2}) async {
    await Future.delayed(Duration(seconds: duracaoEmSegundos));
    try {
      final conta = await carregaContaAtual.carrega();

      _navegaPara.value = conta == null ? '/acesso' : '/pesquisas';
    } catch (e) {
      _navegaPara.value = '/acesso';
    }
  }

  @override
  Stream<String> get navegaParaTransmissor => _navegaPara.stream;
}
