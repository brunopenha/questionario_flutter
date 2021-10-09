import '../../../dados/casosuso/adiciona_conta/adiciona_conta.dart';
import '../../../dominios/casosuso/casosuso.dart';
import '../fabricas.dart';

AdicionaConta criaAdicionaContaRemota() {
  return AdicionaContaRemota(clienteHttp: criaAdaptadorHttp(), url: criaUrlAPI('signup'));
}
