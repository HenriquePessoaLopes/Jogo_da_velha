import 'package:flutter/material.dart';
import 'package:flutter_application_1/jogo/jogo_da_velha.dart';
import 'package:flutter_application_1/main_color.dart';
import 'package:flutter_application_1/widgets/marca.dart';

/// As 9 casas. Sempre quadrado: ocupa o maior quadrado que couber no espaço dado.
class Tabuleiro extends StatelessWidget {
  final JogoDaVelha rodada;
  final ValueChanged<int> aoJogar;

  const Tabuleiro({super.key, required this.rodada, required this.aoJogar});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [for (var i = 0; i < 9; i++) _casa(i)],
      ),
    );
  }

  Widget _casa(int indice) {
    final dono = rodada.casas[indice];
    final destacada = rodada.linhaVencedora.contains(indice);
    final linha = indice ~/ 3 + 1;
    final coluna = indice % 3 + 1;

    return Semantics(
      button: dono == null && !rodada.terminou,
      label:
          'Linha $linha, coluna $coluna, ${dono == null ? 'vazia' : dono.simbolo}',
      excludeSemantics: true,
      child: GestureDetector(
        key: Key('casa-$indice'),
        behavior: HitTestBehavior.opaque,
        onTap: () => aoJogar(indice),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: destacada ? MainColor.accentColor : MainColor.secondaryColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child:
              dono == null ? null : Marca(jogador: dono, destacada: destacada),
        ),
      ),
    );
  }
}
