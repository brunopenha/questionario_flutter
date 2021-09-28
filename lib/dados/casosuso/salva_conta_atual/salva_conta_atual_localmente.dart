import 'package:meta/meta.dart';

import '../../../dominios/casosuso/casosuso.dart';
import '../../../dominios/entidades/entidades.dart';
import '../../../dominios/erros/erros.dart';
import '../../cache/cache.dart';

class SalvaContaAtualLocalmente implements SalvaContaAtual {
  final SalvaArmazenamentoCacheComSeguranca salvaArmazenamentoCacheComSeguranca;

  SalvaContaAtualLocalmente({@required this.salvaArmazenamentoCacheComSeguranca});

  @override
  Future<void> salva(Conta conta) async {
    try {
      await salvaArmazenamentoCacheComSeguranca.salvaComSeguranca(chave: 'token', valor: conta.token);
    } catch (erro) {
      throw ErrosDominio.inesperado;
    }
  }
}
