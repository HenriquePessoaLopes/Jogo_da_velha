import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main_color.dart';
import 'package:google_fonts/google_fonts.dart';

class TictactoePage extends StatefulWidget {
  const TictactoePage({super.key});

  @override
  State<TictactoePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TictactoePage> {
  bool oTurn = true;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];
  int attempts = 0;

  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultDeclaration = '';
  bool winnerFound = false;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  void startTimer(){
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if(seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    )
  );
  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: MainColor.primaryColor,
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Player 0',
                        style: customFontWhite,
                      ),
                      Text(
                        oScore.toString(),
                        style: customFontWhite,
                      )
                    ],
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Player X',
                        style: customFontWhite,
                      ),
                      Text(
                        xScore.toString(),
                        style: customFontWhite,
                      )
                    ],
                  )
                ],
              ),
            ) 
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // _tapped(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 5,
                        color: MainColor.primaryColor,
                      ),
                      color: matchedIndexes.contains(index)
                      ? MainColor.accentColor
                      : MainColor.secondaryColor
                    ),
                    child: Center(
                      child: Text(
                        displayXO[index],
                        style: GoogleFonts.coiny(textStyle: TextStyle(
                          fontSize: 64,
                          color: matchedIndexes.contains(index) 
                          ? MainColor.secondaryColor
                          : MainColor.primaryColor
                        )),
                      ),
                    ),
                  ),
                );
              }
              )
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    resultDeclaration, style: customFontWhite),
                    const SizedBox(height: 10,),
                    // _buildTimer()
                ],
              ),
            ) 
            )
        ],
      ),
      ),
   );
  }
  
}