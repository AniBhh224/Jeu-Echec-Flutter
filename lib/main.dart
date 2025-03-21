import 'package:flutter/material.dart';

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

class ChessBoard extends StatelessWidget {
  static const int boardSize = 8;
  static const Color lightSquare = Color(0xFFEEEED2);
  static const Color darkSquare = Color(0xFF769656);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boardSize,
        ),
        itemBuilder: (context, index) {
          final int row = index ~/ boardSize;
          final int col = index % boardSize;
          final bool isLightSquare = (row + col) % 2 == 0;

          return Container(
            color: isLightSquare ? lightSquare : darkSquare,
          );
        },
        itemCount: boardSize * boardSize,
      ),
    );
  }
}
