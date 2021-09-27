import '../../validacao/dependencias/dependencias.dart';
import '../../validacao/validadores/validadores.dart';

class ConstroiValidacao {
  static ConstroiValidacao _instancia;

  String nomeCampo;
  List<ValidaCampos> validacoes = [];

  ConstroiValidacao._(); // Torna o construtor como privado - estrategia do Singleton no Dartl

  static ConstroiValidacao campo(String nomeCampo) {
    _instancia = ConstroiValidacao._(); // Deixando apenas acessivel de dentro
    _instancia.nomeCampo = nomeCampo;

    return _instancia;
  }

  ConstroiValidacao obrigatorio() {
    validacoes.add(ValidaCamposObrigatorios(nomeCampo));
    return this;
  }

  ConstroiValidacao email() {
    validacoes.add(ValidaEmail(nomeCampo));
    return this;
  }

  List<ValidaCampos> constroi() => validacoes;
}
