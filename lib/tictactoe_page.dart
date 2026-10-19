import 'package:flutter/material.dart';
import 'package:flutter_application_1/jogo/jogo_da_velha.dart';
import 'package:flutter_application_1/jogo/partida.dart';
import 'package:flutter_application_1/main_color.dart';
import 'package:flutter_application_1/widgets/placar.dart';
import 'package:flutter_application_1/widgets/tabuleiro.dart';

/// A tela do jogo. Em pé: placar, tabuleiro e botões, de cima para baixo.
/// Deitada ou em janela larga: tabuleiro de um lado e placar e botões do outro.
class TictactoePage extends StatefulWidget {
  const TictactoePage({super.key});

  @override
  State<TictactoePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TictactoePage> {
  final Partida _partida = Partida();

  void _jogar(int indice) => setState(() => _partida.jogar(indice));

  void _novaRodada() => setState(_partida.novaRodada);

  void _zerarPlacar() => setState(_partida.zerarPlacar);

  String get _mensagem {
    final rodada = _partida.rodada;
    return switch (rodada.situacao) {
      Situacao.emAndamento => 'Vez do jogador ${rodada.vez.simbolo}',
      Situacao.vitoria => 'Jogador ${rodada.vencedor!.simbolo} venceu!',
      Situacao.empate => 'Empate!',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, restricoes) {
            final deitado =
                restricoes.maxWidth >= 640 &&
                restricoes.maxWidth > restricoes.maxHeight * 1.1;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: deitado ? _layoutDeitado() : _layoutEmPe(),
            );
          },
        ),
      ),
    );
  }

  Widget _tabuleiro() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 520),
    child: Tabuleiro(rodada: _partida.rodada, aoJogar: _jogar),
  );

  Widget _layoutEmPe() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          spacing: 16,
          children: [
            Placar(partida: _partida),
            Expanded(child: Center(child: _tabuleiro())),
            _mensagemEBotoes(),
          ],
        ),
      ),
    );
  }

  Widget _layoutDeitado() {
    return Row(
      spacing: 24,
      children: [
        Expanded(child: Center(child: _tabuleiro())),
        SizedBox(
          width: 340,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 24,
                children: [Placar(partida: _partida), _mensagemEBotoes()],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mensagemEBotoes() {
    final terminou = _partida.rodada.terminou;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            _mensagem,
            key: const Key('mensagem'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: MainColor.secondaryColor,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            key: const Key('jogar-de-novo'),
            onPressed: _novaRodada,
            style: FilledButton.styleFrom(
              backgroundColor: MainColor.secondaryColor,
              foregroundColor: MainColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              // Depois do fim da rodada o botão ganha destaque (sombra), pois é a próxima ação.
              elevation: terminou ? 6 : 0,
            ),
            child: Text(terminou ? 'Jogar de novo' : 'Reiniciar rodada'),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            key: const Key('zerar-placar'),
            onPressed: _partida.temPlacar ? _zerarPlacar : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: MainColor.secondaryColor,
              disabledForegroundColor: MainColor.secondaryColor.withValues(
                alpha: 0.4,
              ),
              side: BorderSide(
                color: MainColor.secondaryColor.withValues(
                  alpha: _partida.temPlacar ? 0.9 : 0.3,
                ),
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Zerar placar'),
          ),
        ),
      ],
    );
  }
}
