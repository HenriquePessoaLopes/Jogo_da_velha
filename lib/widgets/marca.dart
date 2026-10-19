import 'package:flutter/material.dart';
import 'package:flutter_application_1/jogo/jogo_da_velha.dart';
import 'package:flutter_application_1/main_color.dart';

/// O X ou o O desenhado numa casa. É desenhado (não é texto), então fica nítido em qualquer
/// tamanho de tela e não depende de nenhuma fonte. Aparece com uma pequena animação.
class Marca extends StatelessWidget {
  final Jogador jogador;

  /// Cor da marca quando a casa faz parte da linha vencedora (sobre o fundo roxo).
  final bool destacada;

  const Marca({super.key, required this.jogador, this.destacada = false});

  @override
  Widget build(BuildContext context) {
    final cor =
        destacada
            ? MainColor.secondaryColor
            : (jogador == Jogador.x ? MainColor.marcaX : MainColor.marcaO);

    return TweenAnimationBuilder<double>(
      key: ValueKey(jogador),
      tween: Tween(begin: 0.4, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      builder:
          (context, escala, _) => Transform.scale(
            scale: escala,
            child: CustomPaint(
              painter: _PintorDaMarca(jogador: jogador, cor: cor),
              size: Size.infinite,
            ),
          ),
    );
  }
}

class _PintorDaMarca extends CustomPainter {
  final Jogador jogador;
  final Color cor;

  _PintorDaMarca({required this.jogador, required this.cor});

  @override
  void paint(Canvas canvas, Size tamanho) {
    final lado = tamanho.shortestSide;
    final centro = tamanho.center(Offset.zero);
    final traco =
        Paint()
          ..color = cor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lado * 0.12;

    if (jogador == Jogador.o) {
      canvas.drawCircle(centro, lado * 0.27, traco);
    } else {
      final r = lado * 0.25;
      canvas.drawLine(centro + Offset(-r, -r), centro + Offset(r, r), traco);
      canvas.drawLine(centro + Offset(r, -r), centro + Offset(-r, r), traco);
    }
  }

  @override
  bool shouldRepaint(_PintorDaMarca antigo) =>
      antigo.jogador != jogador || antigo.cor != cor;
}
