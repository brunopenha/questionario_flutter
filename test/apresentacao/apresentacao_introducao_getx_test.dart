import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/dominios/entidades/entidades.dart';
import 'package:questionario/iu/paginas/introducao/introducao.dart';
import 'package:test/test.dart';

void main() {
  ApresentadorIntroducaoGetx sut;
  CarregaContaAtualSimulada carregaContaAtual;

  void carregaContaAtualSimulada({Conta conta}) {
    when(carregaContaAtual.carrega()).thenAnswer((_) async => conta);
  }

  setUp(() {
    carregaContaAtual = CarregaContaAtualSimulada();
    sut = ApresentadorIntroducaoGetx(carregaContaAtual: carregaContaAtual);
    carregaContaAtualSimulada(conta: Conta(token: faker.guid.guid()));
  });

  test('Deveria chamar CarregaContaAtual', () async {
    await sut.verificaContaAtual();

    verify(carregaContaAtual.carrega()).called(1);
  });

  test('Deveria ir para a pagina de pesquisa quando for tudo ok', () async {
    // A assertiva vira antes do act
    // dentro do list sera chamada uma vez e comparar se a pagina se é a esperada
    sut.navegaParaTransmissor.listen(expectAsync1((pagina) => expect(pagina, '/pesquisas')));

    await sut.verificaContaAtual();
  });

  test('Deveria ir para a pagina de acesso quando o resultado for nulo', () async {
    carregaContaAtualSimulada(conta: null);

    sut.navegaParaTransmissor.listen(expectAsync1((pagina) => expect(pagina, '/acesso')));

    await sut.verificaContaAtual();
  });
}

class CarregaContaAtualSimulada extends Mock implements CarregaContaAtual {}

class ApresentadorIntroducaoGetx implements ApresentadorIntroducao {
  final CarregaContaAtual carregaContaAtual;

  var _navegaPara = RxString();

  ApresentadorIntroducaoGetx({@required this.carregaContaAtual});

  @override
  Future<void> verificaContaAtual() async {
    final conta = await carregaContaAtual.carrega();

    _navegaPara.value = conta == null ? '/acesso' : '/pesquisas';
  }

  @override
  Stream<String> get navegaParaTransmissor => _navegaPara.stream;
}
