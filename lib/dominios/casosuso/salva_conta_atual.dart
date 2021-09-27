import '../entidades/entidades.dart';

abstract class SalvaContaAtual {
  Future<void> salva(Conta conta);
}
