import 'package:flutter/material.dart';
import 'jeu.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu d’échecs',
      home: Scaffold(
        appBar: AppBar(title: const Text('Jeu d’échecs')),
        body: const Jeu(),
      ),
    );
  }
}
