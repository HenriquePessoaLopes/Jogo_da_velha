/// Os dois jogadores.
enum Jogador {
  x('X'),
  o('O');

  final String simbolo;

  const Jogador(this.simbolo);

  Jogador get outro => this == x ? o : x;
}

/// Em que ponto está a rodada.
enum Situacao { emAndamento, vitoria, empate }

/// As regras do jogo da velha, sem nenhuma tela: um tabuleiro de 9 casas (0 a 8, linha por linha).
///
/// ```
///  0 | 1 | 2
///  3 | 4 | 5
///  6 | 7 | 8
/// ```
class JogoDaVelha {
  /// As 8 linhas que dão a vitória: 3 horizontais, 3 verticais e 2 diagonais.
  static const List<List<int>> linhasDeVitoria = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  final List<Jogador?> _casas = List.filled(9, null);
  Jogador _vez;
  Jogador? _vencedor;
  List<int> _linhaVencedora = const [];

  /// Começa uma rodada vazia; [primeiro] é quem faz a primeira jogada.
  JogoDaVelha({Jogador primeiro = Jogador.x}) : _vez = primeiro;

  /// O que há em cada casa (`null` = vazia). A lista devolvida não altera o jogo.
  List<Jogador?> get casas => List.unmodifiable(_casas);

  /// De quem é a vez (depois do fim da rodada, é quem jogaria a seguir).
  Jogador get vez => _vez;

  Jogador? get vencedor => _vencedor;

  /// As três casas da linha vencedora (vazia se ninguém venceu).
  List<int> get linhaVencedora => _linhaVencedora;

  int get jogadasFeitas => _casas.where((c) => c != null).length;

  Situacao get situacao {
    if (_vencedor != null) return Situacao.vitoria;
    if (jogadasFeitas == _casas.length) return Situacao.empate;
    return Situacao.emAndamento;
  }

  bool get terminou => situacao != Situacao.emAndamento;

  /// Joga na casa [indice] para o jogador da vez.
  ///
  /// Devolve `false` (e não muda nada) se a jogada não vale: casa fora de 0 a 8, casa ocupada
  /// ou rodada já terminada.
  bool jogar(int indice) {
    if (terminou ||
        indice < 0 ||
        indice >= _casas.length ||
        _casas[indice] != null) {
      return false;
    }

    _casas[indice] = _vez;
    _procurarVencedor();
    // Depois de uma vitória a vez não passa: assim `vez` ainda mostra quem acabou de ganhar.
    if (_vencedor == null) _vez = _vez.outro;
    return true;
  }

  void _procurarVencedor() {
    for (final linha in linhasDeVitoria) {
      final primeiro = _casas[linha[0]];
      if (primeiro != null &&
          primeiro == _casas[linha[1]] &&
          primeiro == _casas[linha[2]]) {
        _vencedor = primeiro;
        _linhaVencedora = List.unmodifiable(linha);
        return;
      }
    }
  }
}
