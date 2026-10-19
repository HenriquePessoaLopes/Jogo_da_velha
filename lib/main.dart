import 'package:flutter/material.dart';
import 'package:flutter_application_1/main_color.dart';
import 'package:flutter_application_1/tictactoe_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MainColor.primaryColor),
        scaffoldBackgroundColor: MainColor.primaryColor,
      ),
      home: const TictactoePage(),
    );
  }
}
