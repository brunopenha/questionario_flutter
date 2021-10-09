import '../entidades/entidades.dart';

abstract class CarregaPesquisas {
  Future<List<Pesquisa>> carrega();
}
