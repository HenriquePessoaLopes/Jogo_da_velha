import 'package:flutter_application_1/jogo/jogo_da_velha.dart';
import 'package:flutter_test/flutter_test.dart';

/// Faz uma sequência de jogadas, alternando X, O, X, O...
JogoDaVelha jogar(List<int> jogadas, {Jogador primeiro = Jogador.x}) {
  final jogo = JogoDaVelha(primeiro: primeiro);
  for (final casa in jogadas) {
    jogo.jogar(casa);
  }
  return jogo;
}

/// Escolhe 3 casas, entre as dadas, que NÃO formem uma linha de vitória
/// (para o X jogar sem vencer antes da hora).
List<int> tresCasasSemLinha(List<int> casas) {
  for (var a = 0; a < casas.length; a++) {
    for (var b = a + 1; b < casas.length; b++) {
      for (var c = b + 1; c < casas.length; c++) {
        final trio = [casas[a], casas[b], casas[c]]..sort();
        final formaLinha = JogoDaVelha.linhasDeVitoria.any(
          (l) => l[0] == trio[0] && l[1] == trio[1] && l[2] == trio[2],
        );
        if (!formaLinha) return [casas[a], casas[b], casas[c]];
      }
    }
  }
  throw StateError('não há trio sem linha');
}

void main() {
  group('início', () {
    test('tabuleiro vazio, X começa e a rodada está em andamento', () {
      final jogo = JogoDaVelha();
      expect(jogo.casas, everyElement(isNull));
      expect(jogo.casas, hasLength(9));
      expect(jogo.vez, Jogador.x);
      expect(jogo.situacao, Situacao.emAndamento);
      expect(jogo.terminou, isFalse);
      expect(jogo.vencedor, isNull);
      expect(jogo.linhaVencedora, isEmpty);
    });

    test('dá para escolher quem começa', () {
      expect(JogoDaVelha(primeiro: Jogador.o).vez, Jogador.o);
    });

    test('Jogador.outro e símbolos', () {
      expect(Jogador.x.outro, Jogador.o);
      expect(Jogador.o.outro, Jogador.x);
      expect(Jogador.x.simbolo, 'X');
      expect(Jogador.o.simbolo, 'O'); // letra O, não o número zero
    });
  });

  group('jogadas', () {
    test('as jogadas alternam X e O', () {
      final jogo = JogoDaVelha();
      expect(jogo.jogar(4), isTrue);
      expect(jogo.casas[4], Jogador.x);
      expect(jogo.vez, Jogador.o);
      expect(jogo.jogar(0), isTrue);
      expect(jogo.casas[0], Jogador.o);
      expect(jogo.vez, Jogador.x);
    });

    test('casa ocupada é recusada e nada muda', () {
      final jogo = jogar([4]);
      expect(jogo.jogar(4), isFalse);
      expect(jogo.casas[4], Jogador.x);
      expect(jogo.vez, Jogador.o);
      expect(jogo.jogadasFeitas, 1);
    });

    test('casas fora do tabuleiro são recusadas', () {
      final jogo = JogoDaVelha();
      expect(jogo.jogar(-1), isFalse);
      expect(jogo.jogar(9), isFalse);
      expect(jogo.jogar(100), isFalse);
      expect(jogo.jogadasFeitas, 0);
    });

    test('a lista de casas devolvida não altera o jogo', () {
      final jogo = JogoDaVelha();
      expect(() => jogo.casas[0] = Jogador.x, throwsUnsupportedError);
      expect(jogo.casas[0], isNull);
    });
  });

  group('vitória', () {
    // Para cada linha, X completa a linha e O joga em casas que não atrapalham nem completam nada.
    for (final linha in JogoDaVelha.linhasDeVitoria) {
      test('X vence na linha $linha', () {
        final outras = [
          for (var i = 0; i < 9; i++)
            if (!linha.contains(i)) i,
        ];
        final jogo = jogar([
          linha[0],
          outras[0],
          linha[1],
          outras[1],
          linha[2],
        ]);

        expect(jogo.situacao, Situacao.vitoria);
        expect(jogo.vencedor, Jogador.x);
        expect(jogo.linhaVencedora, linha);
        expect(jogo.terminou, isTrue);
      });

      test('O vence na linha $linha', () {
        final outras = [
          for (var i = 0; i < 9; i++)
            if (!linha.contains(i)) i,
        ];
        final casasDoX = tresCasasSemLinha(outras);
        final jogo = jogar([
          casasDoX[0],
          linha[0],
          casasDoX[1],
          linha[1],
          casasDoX[2],
          linha[2],
        ]);

        expect(jogo.vencedor, Jogador.o);
        expect(jogo.linhaVencedora, linha);
      });
    }

    test('depois da vitória nenhuma jogada vale', () {
      final jogo = jogar([0, 3, 1, 4, 2]); // X venceu na linha de cima
      expect(jogo.jogar(8), isFalse);
      expect(jogo.casas[8], isNull);
      expect(jogo.vencedor, Jogador.x);
      expect(jogo.vez, Jogador.x, reason: 'a vez não passa depois da vitória');
    });

    test('vitória na nona jogada é vitória, não empate', () {
      // X O O
      // O X X
      // O X X   -> X completa a diagonal [0, 4, 8] justamente na 9ª jogada.
      final jogo = jogar([0, 1, 4, 2, 5, 3, 7, 6, 8]);

      expect(jogo.jogadasFeitas, 9);
      expect(jogo.situacao, Situacao.vitoria);
      expect(jogo.vencedor, Jogador.x);
      expect(jogo.linhaVencedora, [0, 4, 8]);
    });

    test('uma jogada que fecha duas fileiras: vale a primeira da lista', () {
      // O último movimento do X (casa 0) fecha [0, 1, 2] e [0, 3, 6] ao mesmo tempo.
      final jogo = jogar([1, 4, 2, 5, 3, 7, 6, 8, 0]);

      expect(jogo.vencedor, Jogador.x);
      expect(jogo.linhaVencedora, [0, 1, 2]);
    });
  });

  group('empate', () {
    test('tabuleiro cheio sem vencedor é empate', () {
      // X O X
      // X O O
      // O X X
      final jogo = jogar([0, 1, 2, 4, 3, 5, 7, 6, 8]);
      expect(jogo.situacao, Situacao.empate);
      expect(jogo.vencedor, isNull);
      expect(jogo.linhaVencedora, isEmpty);
      expect(jogo.terminou, isTrue);
    });

    test('depois do empate nenhuma jogada vale', () {
      final jogo = jogar([0, 1, 2, 4, 3, 5, 7, 6, 8]);
      expect(jogo.jogar(0), isFalse);
    });
  });
}
