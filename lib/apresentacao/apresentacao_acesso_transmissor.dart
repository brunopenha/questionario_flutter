import 'dart:async';

import 'package:meta/meta.dart';

import 'dependencias/dependencias.dart';

class EstadoAcesso {
  String erroEmail;
  String erroSenha;

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
  Stream<String> get senhaComErroStream => _controlador.stream.map((estado) => estado.erroSenha).distinct();

  Stream<bool> get camposSaoValidosStream =>
      _controlador.stream.map((estado) => estado.estaValido).distinct();

  void atualiza() => _controlador.add(_estado);

  void validaEmail(String email) {
    _estado.erroEmail = validador.valida(campo: 'email', valor: email);
    atualiza();
  }

  void validaSenha(String textoSenha) {
    _estado.erroSenha = validador.valida(campo: 'senha', valor: textoSenha);
    atualiza();
  }
}
