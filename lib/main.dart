import 'package:flutter/material.dart';
import 'board.dart'; // importe le fichier avec le plateau

void main() {
  runApp(ChessBoardApp());
}

class ChessBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess.com Style Board',
      home: Scaffold(
        appBar: AppBar(title: Text('Chess.com Board')),
        body: Center(child: ChessBoard()),
      ),
    );
  }
}
