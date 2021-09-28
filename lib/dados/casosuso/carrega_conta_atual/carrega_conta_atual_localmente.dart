import 'package:meta/meta.dart';

import '../../../dominios/casosuso/casosuso.dart';
import '../../../dominios/entidades/entidades.dart';
import '../../../dominios/erros/erros.dart';
import '../../cache/cache.dart';

class CarregaContaAtualLocalmente implements CarregaContaAtual {
  final ObtemCacheArmazenadoComSeguranca obtemCacheArmazenadoComSeguranca;

  CarregaContaAtualLocalmente({@required this.obtemCacheArmazenadoComSeguranca});

  @override
  Future<Conta> carrega() async {
    try {
      final tokenRetornado = await obtemCacheArmazenadoComSeguranca.obtemComSeguranca('token');
      return Conta(token: tokenRetornado);
    } catch (e) {
      throw ErrosDominio.inesperado;
    }
  }
}
