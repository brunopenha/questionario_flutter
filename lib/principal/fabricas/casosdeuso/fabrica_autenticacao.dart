import '../../../dados/casosuso/casosuso.dart';
import '../../../dominios/casosuso/casosuso.dart';
import '../fabricas.dart';

Autenticador criaAuteticacaoRemota() {
  return AutenticacaoRemota(clienteHttp: criaAdaptadorHttp(), url: criaUrlAPI('login'));
}
