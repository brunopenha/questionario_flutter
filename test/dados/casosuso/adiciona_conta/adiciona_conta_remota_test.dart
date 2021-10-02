import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dados/http/http.dart';
import 'package:test/test.dart';

class ClienteHttpSimulado extends Mock implements ClienteHttp {}

class AdicionaContaRemota {
  final ClienteHttp clienteHttp;
  final String url;

  AdicionaContaRemota({@required this.clienteHttp, @required this.url});

  Future<void> adiciona(ParametrosAdicionaContaRemota parametro) async {
    final body = ParametrosAdicionaContaRemota.aPartirDoDominio(parametro).criaJson();
    await clienteHttp.requisita(url: url, metodo: 'post', corpo: body);
  }
}

class ParametrosAdicionaContaRemota {
  final String nome;
  final String email;
  final String senha;
  final String confirmaSenha;

  ParametrosAdicionaContaRemota(
      {@required this.nome, @required this.email, @required this.senha, @required this.confirmaSenha});

  factory ParametrosAdicionaContaRemota.aPartirDoDominio(ParametrosAdicionaContaRemota entidade) =>
      ParametrosAdicionaContaRemota(
          nome: entidade.nome,
          email: entidade.email,
          senha: entidade.senha,
          confirmaSenha: entidade.confirmaSenha);

  // acesso a API para verificar os parametros:
  // https://fordevs.herokuapp.com/api-docs/#/Login/post_signup
  Map criaJson() => {'name': nome, 'email': email, 'password': senha, 'passwordConfirmation': confirmaSenha};
}

void main() {
  // sut - System Under Test - "Quem estou testando?"
  AdicionaContaRemota sut;

  ClienteHttpSimulado clienteHttp;
  String urlSimulada;
  String senhaSimulada = faker.internet.password();
  ParametrosAdicionaContaRemota parametros;

  setUp(() {
    clienteHttp = ClienteHttpSimulado();
    urlSimulada = faker.internet.httpUrl();
    sut = AdicionaContaRemota(clienteHttp: clienteHttp, url: urlSimulada);
    parametros = ParametrosAdicionaContaRemota(
        nome: faker.person.name(),
        email: faker.internet.email(),
        senha: senhaSimulada,
        confirmaSenha: senhaSimulada);
  });

  test("Deveria chamar o ClienteHttp com a URL correta", () async {
    await sut.adiciona(parametros);

    verify(clienteHttp.requisita(url: urlSimulada, metodo: 'post', corpo: {
      'name': parametros.nome,
      'email': parametros.email,
      'password': parametros.senha,
      'passwordConfirmation': parametros.confirmaSenha
    }));
  });
}
