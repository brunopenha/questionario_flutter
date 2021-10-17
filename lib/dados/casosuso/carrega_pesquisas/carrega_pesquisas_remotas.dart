import 'package:meta/meta.dart';

import '../../../dominios/casosuso/casosuso.dart';
import '../../../dominios/entidades/entidades.dart';
import '../../../dominios/erros/erros.dart';
import '../../http/http.dart';
import '../../modelos/modelos.dart';

class CarregaPesquisasRemota implements CarregaPesquisas {
  final String caminho;
  final ClienteHttp<List<Map>> clienteHttp;

  CarregaPesquisasRemota({@required this.caminho, @required this.clienteHttp});

  Future<List<Pesquisa>> carrega() async {
    try {
      final retornoHttp = await clienteHttp.requisita(caminho: caminho, metodo: 'get');
      return retornoHttp.map((json) => ModeloPesquisaRemota.doJson(json).paraEntidade()).toList();
    } on ErrosHttp catch (erro) {
      throw erro == ErrosHttp.forbidden ? ErrosDominio.acessoNegado : ErrosDominio.inesperado;
    }
  }
}
