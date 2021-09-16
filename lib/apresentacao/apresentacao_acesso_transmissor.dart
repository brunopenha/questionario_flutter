import 'dart:async';

import 'package:meta/meta.dart';

import 'dependencias/dependencias.dart';

class EstadoAcesso {
  String erroEmail;
  // estaValido ele é um valor calculado caso algum dos campos não estejam validos
  bool get estaValido => false;
}

class ApresentacaoAcessoTransmissor {
  final Validador validador;

  // Se houvesse um controlador para cada Streaming, não se utiliza broadcast
  final _controlador = StreamController<
      EstadoAcesso>.broadcast(); // Com o broadcast, vou ter mais de um Listener (ouvinte) para um Controlador

  var _estado = EstadoAcesso();

  ApresentacaoAcessoTransmissor({@required this.validador});

  // Toda vez que houver uma alteração nesse estado, algo deverá ser feito
  Stream<String> get emailComErroStream => _controlador.stream
      .map((estado) => estado.erroEmail)
      .distinct(); // Esse distict faz com que o transmissor emita apenas valores diferente do anterior, evita enviar dois valores iguais seguidamente

  Stream<bool> get camposSaoValidosStream =>
      _controlador.stream.map((estado) => estado.estaValido).distinct();

  void validaEmail(String email) {
    _estado.erroEmail = validador.valida(campo: 'email', valor: email);
    _controlador.add(_estado);
  }
}
