import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:questionario/dominios/casosuso/casosuso.dart';
import 'package:questionario/iu/paginas/introducao/introducao.dart';
import 'package:test/test.dart';

void main() {
  test('Deveria chamar CarregaContaAtual', () async {
    final carregaContaAtual = CarregaContaAtualSimulada();
    final sut = ApresentadorIntroducaoGetx(carregaContaAtual: carregaContaAtual);

    await sut.verificaContaAtual();

    verify(carregaContaAtual.carrega()).called(1);
  });
}

class CarregaContaAtualSimulada extends Mock implements CarregaContaAtual {}

class ApresentadorIntroducaoGetx implements ApresentadorIntroducao {
  final CarregaContaAtual carregaContaAtual;

  var _navegaPara = RxString();

  ApresentadorIntroducaoGetx({@required this.carregaContaAtual});

  @override
  Future<void> verificaContaAtual() async {
    await carregaContaAtual.carrega();
  }

  @override
  Stream<String> get navegaParaTransmissor => _navegaPara.stream;
}
