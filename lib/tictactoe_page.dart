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
  
  bool gameStarted = false;

  void startTimer(){
  
    timer?.cancel();
    seconds = maxSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if(seconds > 0) {
          seconds--;
        } else {
          stopTimer();
          _resetWaitingForStart(); 
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
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _tapped(index); 
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
                    if (winnerFound) _buildTimer(),
                    if (!winnerFound && !gameStarted) _buildStartButton(),
                ],
              ),
            ) 
            )
        ],
      ),
      ),
   );
  }



  void _tapped(int index) {
    if (!gameStarted || winnerFound) return;
    if (displayXO[index].isNotEmpty) return;

    setState(() {
      displayXO[index] = oTurn ? '0' : 'X';
      filledBoxes++;
      attempts++;
      _checkWinner();
      if (!winnerFound) {
        oTurn = !oTurn;
        resultDeclaration = oTurn ? 'Vez do Player 0' : 'Vez do Player X';
      }
    });
  }

  void _checkWinner() {
    const win = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
    ];

    for (final p in win) {
      final a=p[0], b=p[1], c=p[2];
      final s1=displayXO[a], s2=displayXO[b], s3=displayXO[c];
      if (s1.isNotEmpty && s1==s2 && s2==s3) {
        matchedIndexes = [a,b,c];
        winnerFound = true;
        if (s1=='0') {
          oScore++;
          resultDeclaration = 'Player 0 venceu!';
        } else {
          xScore++;
          resultDeclaration = 'Player X venceu!';
        }
        gameStarted = false;
        startTimer(); 
        return;
      }
    }

    if (filledBoxes == 9 && !winnerFound) {
      winnerFound = true;
      resultDeclaration = 'Empate!';
      gameStarted = false;
      startTimer();
    }
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _clearBoard();
          winnerFound = false;
          gameStarted = true;
          oTurn = true; 
          resultDeclaration = 'PLAYER 0 VS PLAYER X';
          stopTimer(); 
        });
      },
      child: const Text('Start'),
    );
  }

  Widget _buildTimer() {
    
    return Column(
      children: [
        Text('Reinício em: $seconds s', style: customFontWhite),
        const SizedBox(height: 4),
        
      ],
    );
  }

  void _clearBoard() {
    displayXO = ['', '', '', '', '', '', '', '', ''];
    matchedIndexes = [];
    filledBoxes = 0;
  }

  void _resetWaitingForStart() {
    setState(() {
      _clearBoard();
      winnerFound = false;
      gameStarted = false; 
      oTurn = true;
      resultDeclaration = '';
    });
  }
}
