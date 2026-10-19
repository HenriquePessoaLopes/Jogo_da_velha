import 'package:flutter/material.dart';
import 'package:flutter_application_1/jogo/jogo_da_velha.dart';
import 'package:flutter_application_1/jogo/partida.dart';
import 'package:flutter_application_1/main_color.dart';

/// Placar com as vitórias de cada jogador e os empates. O cartão de quem joga agora
/// (ou de quem venceu) fica branco, para a vez ficar óbvia sem ler nada.
class Placar extends StatelessWidget {
  final Partida partida;

  const Placar({super.key, required this.partida});

  @override
  Widget build(BuildContext context) {
    final rodada = partida.rodada;
    final emAndamento = rodada.situacao == Situacao.emAndamento;
    final vitoria = rodada.situacao == Situacao.vitoria;

    bool ativo(Jogador j) =>
        emAndamento ? rodada.vez == j : (vitoria && rodada.vencedor == j);

    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: _Cartao(
            chave: 'placar-x',
            titulo: 'Jogador X',
            valor: partida.vitoriasX,
            ativo: ativo(Jogador.x),
          ),
        ),
        Expanded(
          child: _Cartao(
            chave: 'placar-empates',
            titulo: 'Empates',
            valor: partida.empates,
            ativo: !emAndamento && !vitoria,
          ),
        ),
        Expanded(
          child: _Cartao(
            chave: 'placar-o',
            titulo: 'Jogador O',
            valor: partida.vitoriasO,
            ativo: ativo(Jogador.o),
          ),
        ),
      ],
    );
  }
}

class _Cartao extends StatelessWidget {
  final String chave;
  final String titulo;
  final int valor;
  final bool ativo;

  const _Cartao({
    required this.chave,
    required this.titulo,
    required this.valor,
    required this.ativo,
  });

  @override
  Widget build(BuildContext context) {
    final corDoTexto =
        ativo ? MainColor.primaryColor : MainColor.secondaryColor;

    return Semantics(
      label: '$titulo: $valor',
      excludeSemantics: true,
      child: AnimatedContainer(
        key: Key(chave),
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color:
              ativo
                  ? MainColor.secondaryColor
                  : MainColor.secondaryColor.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: MainColor.secondaryColor.withValues(alpha: ativo ? 1 : 0.35),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                titulo,
                maxLines: 1,
                style: TextStyle(
                  color: corDoTexto,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$valor',
              key: Key('$chave-valor'),
              style: TextStyle(
                color: corDoTexto,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
