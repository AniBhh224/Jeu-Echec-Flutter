import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jeu d\'Échecs',
      home: ChessBoardScreen(),
    );
  }
}

class ChessBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Échiquier Flutter')),
      body: Center(
        child: ChessBoard(),
      ),
    );
  }
}

class ChessBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Carré
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // 8 colonnes
        ),
        itemBuilder: (context, index) {
          int row = index ~/ 8; // Ligne actuelle
          int col = index % 8;  // Colonne actuelle
          bool isDarkSquare = (row + col) % 2 == 1;

          return Container(
            decoration: BoxDecoration(
              color: isDarkSquare ? Colors.brown : Colors.white,
            ),
          );
        },
        itemCount: 64, // 8x8 cases
      ),
    );
  }
}
