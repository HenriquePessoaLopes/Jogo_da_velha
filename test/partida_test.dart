import 'package:flutter_application_1/jogo/jogo_da_velha.dart';
import 'package:flutter_application_1/jogo/partida.dart';
import 'package:flutter_test/flutter_test.dart';

void jogarTudo(Partida p, List<int> casas) {
  for (final casa in casas) {
    p.jogar(casa);
  }
}

/// X vence na linha de cima (O joga 3 e 4).
const vitoriaDoX = [0, 3, 1, 4, 2];

/// O vence na linha de cima (X joga 3, 4 e 8).
const vitoriaDoO = [3, 0, 4, 1, 8, 2];

/// Tabuleiro cheio sem vencedor, com X abrindo.
const empateComXAbrindo = [0, 1, 2, 4, 3, 5, 7, 6, 8];

void main() {
  test('começa zerada, com X abrindo', () {
    final p = Partida();
    expect((p.vitoriasX, p.vitoriasO, p.empates), (0, 0, 0));
    expect(p.temPlacar, isFalse);
    expect(p.rodada.vez, Jogador.x);
  });

  test('vitória do X soma ponto para o X', () {
    final p = Partida();
    jogarTudo(p, vitoriaDoX);
    expect((p.vitoriasX, p.vitoriasO, p.empates), (1, 0, 0));
    expect(p.vitoriasDe(Jogador.x), 1);
    expect(p.temPlacar, isTrue);
  });

  test('vitória do O soma ponto para o O', () {
    final p = Partida();
    jogarTudo(p, vitoriaDoO);
    expect((p.vitoriasX, p.vitoriasO, p.empates), (0, 1, 0));
    expect(p.vitoriasDe(Jogador.o), 1);
  });

  test('empate soma um empate', () {
    final p = Partida();
    jogarTudo(p, empateComXAbrindo);
    expect((p.vitoriasX, p.vitoriasO, p.empates), (0, 0, 1));
  });

  test('jogadas depois do fim não contam o ponto duas vezes', () {
    final p = Partida();
    jogarTudo(p, vitoriaDoX);
    expect(p.jogar(8), isFalse);
    expect(p.jogar(5), isFalse);
    expect(p.vitoriasX, 1);
  });

  test('jogada inválida não mexe no placar nem na vez', () {
    final p = Partida();
    p.jogar(4);
    expect(p.jogar(4), isFalse);
    expect(p.jogar(42), isFalse);
    expect(p.rodada.vez, Jogador.o);
    expect(p.temPlacar, isFalse);
  });

  group('nova rodada', () {
    test('limpa o tabuleiro e mantém o placar', () {
      final p = Partida();
      jogarTudo(p, vitoriaDoX);
      p.novaRodada();

      expect(p.rodada.casas, everyElement(isNull));
      expect(p.rodada.situacao, Situacao.emAndamento);
      expect(p.vitoriasX, 1);
    });

    test('quem abre o jogo alterna a cada rodada terminada', () {
      final p = Partida();
      expect(p.rodada.vez, Jogador.x);

      jogarTudo(p, vitoriaDoX);
      p.novaRodada();
      expect(p.rodada.vez, Jogador.o, reason: 'na 2ª rodada o O abre');

      p.novaRodada(); // descarta a 2ª rodada, que nem começou a terminar
      expect(
        p.rodada.vez,
        Jogador.o,
        reason: 'rodada descartada não troca quem abre',
      );

      jogarTudo(p, [0, 3, 1, 4, 2]); // O abre e vence
      p.novaRodada();
      expect(p.rodada.vez, Jogador.x, reason: 'na 3ª rodada, X abre de novo');
    });

    test('depois de uma rodada nova, o placar volta a contar normalmente', () {
      final p = Partida();
      jogarTudo(p, vitoriaDoX);
      p.novaRodada();
      jogarTudo(p, [0, 3, 1, 4, 2]); // O abre e vence na linha de cima
      expect((p.vitoriasX, p.vitoriasO), (1, 1));
    });
  });

  test('zerar o placar limpa tudo e devolve a abertura ao X', () {
    final p = Partida();
    jogarTudo(p, vitoriaDoX);
    p.novaRodada(); // O abre agora
    jogarTudo(p, [0, 3, 1, 4, 2]);
    p.zerarPlacar();

    expect((p.vitoriasX, p.vitoriasO, p.empates), (0, 0, 0));
    expect(p.temPlacar, isFalse);
    expect(p.rodada.casas, everyElement(isNull));
    expect(p.rodada.vez, Jogador.x);
  });
}
