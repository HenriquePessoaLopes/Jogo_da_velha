import 'package:flutter/material.dart';

/// Cores do jogo: fundo azul, casas brancas e roxo para destacar a linha vencedora.
class MainColor {
  static const Color primaryColor = Color.fromARGB(255, 27, 73, 224);
  static const Color secondaryColor = Color.fromARGB(255, 255, 255, 255);
  static const Color accentColor = Color.fromARGB(255, 82, 60, 182);

  /// Marca do X (azul do tema) e do O (azul-claro), para dar para diferenciar de longe.
  static const Color marcaX = primaryColor;
  static const Color marcaO = Color.fromARGB(255, 24, 160, 251);
}
