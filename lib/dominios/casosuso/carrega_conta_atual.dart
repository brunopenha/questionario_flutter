import '../entidades/entidades.dart';

abstract class CarregaContaAtual {
  Future<Conta> carrega();
}
