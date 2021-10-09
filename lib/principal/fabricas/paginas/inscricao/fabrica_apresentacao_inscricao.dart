import '../../../../apresentacao/apresentacao.dart';
import '../../../../iu/paginas/paginas.dart';
import '../../fabricas.dart';
import '../paginas.dart';

ApresentadorInscricao criaApresentadorInscricaoGetx() => ApresentacaoInscricaoGetx(
    adicionaConta: criaAdicionaContaRemota(),
    validador: criaValidadorInscricao(),
    salvaContaAtual: criaSalvaContaAtualLocalmente());
