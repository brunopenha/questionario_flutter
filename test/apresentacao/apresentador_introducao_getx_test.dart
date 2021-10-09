import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/apresentacao/apresentacao.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/entidades.dart';
import 'package:test/test.dart';

void main() {
  ApresentadorIntroducaoGetx sut;
  CarregaContaAtualSimulada carregaContaAtual;

  PostExpectation<Future<Conta>> chamaCarregaContaAtualSimulado() => when(carregaContaAtual.carrega());

  void carregaContaAtualSimulada({Conta conta}) {
    chamaCarregaContaAtualSimulado().thenAnswer((_) async => conta);
  }

  void carregaContaAtualSimuladaComErro() {
    chamaCarregaContaAtualSimulado().thenThrow(Exception());
  }

  setUp(() {
    carregaContaAtual = CarregaContaAtualSimulada();
    sut = ApresentadorIntroducaoGetx(carregaContaAtual: carregaContaAtual);
    carregaContaAtualSimulada(conta: Conta(token: faker.guid.guid()));
  });

  test('Deveria chamar CarregaContaAtual', () async {
    await sut.verificaContaAtual(duracaoEmSegundos: 0);

    verify(carregaContaAtual.carrega()).called(1);
  });

  test('Deveria ir para a pagina de pesquisa quando for tudo ok', () async {
    // A assertiva vira antes do act
    // dentro do list sera chamada uma vez e comparar se a pagina se é a esperada
    sut.navegaParaTransmissor.listen(expectAsync1((pagina) => expect(pagina, '/pesquisas')));

    await sut.verificaContaAtual(duracaoEmSegundos: 0);
  });

  test('Deveria ir para a pagina de acesso quando o resultado for nulo', () async {
    carregaContaAtualSimulada(conta: null);

    sut.navegaParaTransmissor.listen(expectAsync1((pagina) => expect(pagina, '/acesso')));

    await sut.verificaContaAtual(duracaoEmSegundos: 0);
  });

  test('Deveria ir para a pagina de acesso quando o token for nulo', () async {
    carregaContaAtualSimulada(conta: Conta(token: null));

    sut.navegaParaTransmissor.listen(expectAsync1((pagina) => expect(pagina, '/acesso')));

    await sut.verificaContaAtual(duracaoEmSegundos: 0);
  });

  test('Deveria ir para a pagina de acesso quando houver um erro ou exceção', () async {
    carregaContaAtualSimuladaComErro();

    sut.navegaParaTransmissor.listen(expectAsync1((pagina) => expect(pagina, '/acesso')));

    await sut.verificaContaAtual(duracaoEmSegundos: 0);
  });
}

class CarregaContaAtualSimulada extends Mock implements CarregaContaAtual {}
