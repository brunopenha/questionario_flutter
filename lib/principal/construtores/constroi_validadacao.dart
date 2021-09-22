import '../../validacao/dependencias/dependencias.dart';
import '../../validacao/validadores/validadores.dart';

class ConstroiValidacao {
  static ConstroiValidacao _instancia;

  String nomeCampo;
  List<ValidaCampos> validacoes = [];

  static ConstroiValidacao campo(String nomeCampo) {
    _instancia = ConstroiValidacao();
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
