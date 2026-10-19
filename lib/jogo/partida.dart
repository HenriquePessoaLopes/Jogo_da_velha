import 'jogo_da_velha.dart';

/// Uma sequência de rodadas entre os mesmos dois jogadores, com placar.
///
/// Quem começa alterna a cada rodada (para ninguém levar vantagem de sempre abrir o jogo).
class Partida {
  JogoDaVelha _rodada;
  Jogador _quemComeca;
  bool _jaContou = false;

  int _vitoriasX = 0;
  int _vitoriasO = 0;
  int _empates = 0;

  Partida({Jogador primeiro = Jogador.x})
    : _quemComeca = primeiro,
      _rodada = JogoDaVelha(primeiro: primeiro);

  /// A rodada em andamento (ou a que acabou de terminar).
  JogoDaVelha get rodada => _rodada;

  int get vitoriasX => _vitoriasX;
  int get vitoriasO => _vitoriasO;
  int get empates => _empates;

  int vitoriasDe(Jogador jogador) =>
      jogador == Jogador.x ? _vitoriasX : _vitoriasO;

  bool get temPlacar => _vitoriasX + _vitoriasO + _empates > 0;

  /// Faz uma jogada. Quando ela encerra a rodada, o placar é atualizado (uma única vez).
  /// Devolve `false` se a jogada não vale (casa ocupada, fora do tabuleiro ou rodada encerrada).
  bool jogar(int indice) {
    final valeu = _rodada.jogar(indice);
    if (valeu && _rodada.terminou && !_jaContou) {
      _jaContou = true;
      switch (_rodada.situacao) {
        case Situacao.vitoria:
          if (_rodada.vencedor == Jogador.x) {
            _vitoriasX++;
          } else {
            _vitoriasO++;
          }
        case Situacao.empate:
          _empates++;
        case Situacao.emAndamento:
          break;
      }
    }
    return valeu;
  }

  /// Limpa o tabuleiro para outra rodada, mantendo o placar. Quem abre o jogo troca.
  /// Se a rodada atual nem terminou, ela é descartada e quem começa não troca.
  void novaRodada() {
    if (_rodada.terminou) _quemComeca = _quemComeca.outro;
    _rodada = JogoDaVelha(primeiro: _quemComeca);
    _jaContou = false;
  }

  /// Zera as vitórias e os empates e recomeça com o X abrindo.
  void zerarPlacar() {
    _vitoriasX = 0;
    _vitoriasO = 0;
    _empates = 0;
    _quemComeca = Jogador.x;
    _rodada = JogoDaVelha(primeiro: _quemComeca);
    _jaContou = false;
  }
}
