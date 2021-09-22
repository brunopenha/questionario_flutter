import 'package:http/http.dart';

import '../../../dados/http/http.dart';
import '../../../infra/http/http.dart';

ClienteHttp criaAdaptadorHttp() {
  final cliente = Client();
  return AdaptadorHttp(cliente);
}
