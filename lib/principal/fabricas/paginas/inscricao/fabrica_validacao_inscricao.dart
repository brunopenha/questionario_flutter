import '../../../../apresentacao/dependencias/validador.dart';
import '../../../../validacao/dependencias/dependencias.dart';
import '../../../../validacao/validadores/validadores.dart';
import '../../../construtores/construtores.dart';

Validador criaValidadorInscricao() {
  return ValidadorComposto(criaValidacoesInscricao());
}

// Builder Design Pattern
List<ValidadorCampos> criaValidacoesInscricao() {
  // Para concatenar duas listas, utilize o SPREAD OPERATOR
  // "..." == SPREAD OPERATOR --> Pega todos os elementos da lista, separa eles e colocar dentro da lista mais externa
  return [
    ...ConstroiValidacao.campo('email').obrigatorio().email().constroi(),
    ...ConstroiValidacao.campo('senha').obrigatorio().min(3).constroi(),
    ...ConstroiValidacao.campo('confirmaSenha').obrigatorio().igualAo('senha').constroi(),
  ];
}
