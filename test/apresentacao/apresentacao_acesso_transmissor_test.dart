import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/apresentacao/dependencias/dependencias.dart';

class EstadoAcesso {
  String erroEmail;
}

class ApresentacaoAcessoTransmissor {
  final Validador validador;

  // Se houvesse um controlador para cada Streaming, não se utiliza broadcast
  final _controlador = StreamController<
      EstadoAcesso>.broadcast(); // Com o broadcast, vou ter mais de um Listener (ouvinte) para um Controlador

  var _estado = EstadoAcesso();

  ApresentacaoAcessoTransmissor({@required this.validador});

  Stream<String> get emailComErroStream => _controlador.stream.map(
      (estado) => estado.erroEmail); // Toda vez que houver uma alteração nesse estado, algo deverá ser feito

  void validaEmail(String email) {
    _estado.erroEmail = validador.valida(campo: 'email', valor: email);
    _controlador.add(_estado);
  }
}

class ValidadorSimulado extends Mock implements Validador {}

void main() {
  ApresentacaoAcessoTransmissor sut;
  ValidadorSimulado validadorSimulado;
  String textoEmail;

  PostExpectation chamadaValidadorSimulado(String campoParam) => when(validadorSimulado.valida(
      campo: campoParam == null ? anyNamed('campo') : campoParam, valor: anyNamed('valor')));

  void chamaValidadorSimulado({String campo, String valor}) {
    chamadaValidadorSimulado(campo).thenReturn(valor);
  }

  setUp(() {
    validadorSimulado = ValidadorSimulado();
    sut = ApresentacaoAcessoTransmissor(validador: validadorSimulado);
    textoEmail = faker.internet.email();

    chamaValidadorSimulado();
  });

  test('Deveria chamar o Validador com o email correto', () {
    sut.validaEmail(textoEmail);

    verify(validadorSimulado.valida(campo: 'email', valor: textoEmail)).called(1);
  });

  test('Deveria transmitir erro no email se a validação falhar', () {
    chamaValidadorSimulado(valor: 'Erro no email');

    expectLater(sut.emailComErroStream,
        emits('Erro no email')); // Vai acontecer depois que rodar a ultima linha do teste

    sut.validaEmail(textoEmail);
  });
}
