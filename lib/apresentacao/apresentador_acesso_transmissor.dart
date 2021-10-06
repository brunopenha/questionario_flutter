import 'dart:async';

import 'package:meta/meta.dart';

import '../dominios/casosuso/casosuso.dart';
import '../dominios/erros/erros.dart';
import '../iu/erros/erros.dart';
import '../iu/paginas/paginas.dart';
import 'dependencias/dependencias.dart';

class EstadoAcesso {
  String email;
  String senha;
  ErrosIU erroEmail;
  ErrosIU erroSenha;
  ErrosIU erroSistema;
  bool estaCarregando = false;

  // estaValido ele é um valor calculado caso algum dos campos não estejam validos
  bool get estaValido => erroEmail == null && erroSenha == null && email != null && senha != null;
}

class ApresentacaoAcessoTransmissor implements ApresentadorAcesso {
  final Validador validador;
  final Autenticador autenticador;

  // Se houvesse um controlador para cada Streaming, não se utiliza broadcast
  var _controlador = StreamController<
      EstadoAcesso>.broadcast(); // Com o broadcast, vou ter mais de um Listener (ouvinte) para um Controlador

  var _estado = EstadoAcesso();

  ApresentacaoAcessoTransmissor({@required this.validador, @required this.autenticador});

  // Toda vez que houver uma alteração nesse estado, algo deverá ser feito
  Stream<ErrosIU> get emailComErroStream => _controlador?.stream
      ?.map((estado) => estado.erroEmail)
      ?.distinct(); // Esse distict faz com que o transmissor emita apenas valores diferente do anterior, evita enviar dois valores iguais seguidamente

  Stream<ErrosIU> get senhaComErroStream =>
      _controlador?.stream?.map((estado) => estado.erroSenha)?.distinct();
  Stream<ErrosIU> get falhaAcessoStream =>
      _controlador?.stream?.map((estado) => estado.erroSistema)?.distinct();
  Stream<String> get navegaParaStream => throw UnimplementedError();

  Stream<bool> get camposSaoValidosStream =>
      _controlador?.stream?.map((estado) => estado.estaValido)?.distinct();

  Stream<bool> get paginaEstaCarregandoStream =>
      _controlador?.stream?.map((estado) => estado.estaCarregando)?.distinct();

  void _atualiza() => _controlador?.add(_estado);

  ErrosIU _validaCampo({String campo, String valor}) {
    final erro = validador.valida(campo: campo, valor: valor);
    switch (erro) {
      case ErroValidacao.DADO_INVALIDO:
        return ErrosIU.DADO_INVALIDO;
      case ErroValidacao.EMAIL_INVALIDO:
        return ErrosIU.EMAIL_INVALIDO;
      case ErroValidacao.EMAIL_INVALIDO:
        return ErrosIU.EMAIL_INVALIDO;

      default:
        return null;
    }
  }

  void validaEmail(String textoEmail) {
    _estado.email = textoEmail;
    _estado.erroEmail = _validaCampo(campo: 'email', valor: textoEmail);
    _atualiza();
  }

  void validaSenha(String textoSenha) {
    _estado.senha = textoSenha;
    _estado.erroSenha = _validaCampo(campo: 'senha', valor: textoSenha);
    _atualiza();
  }

  Future<void> autenticacao() async {
    _estado.estaCarregando = true;
    _atualiza();

    try {
      await autenticador.autoriza(ParametrosAutenticador(email: _estado.email, senha: _estado.senha));
    } on ErrosDominio catch (erro) {
      switch (erro) {
        case ErrosDominio.credenciaisInvalidas:
          _estado.erroSistema = ErrosIU.CREDENCIAIS_INVALIDAS;
          break;
        default:
          _estado.erroSistema = ErrosIU.INESPERADO;
      }
    } finally {
      _estado.estaCarregando = false;
      _atualiza();
    }
  }

  void liberaMemoria() {
    _controlador?.close();
    _controlador = null;
  }
}
