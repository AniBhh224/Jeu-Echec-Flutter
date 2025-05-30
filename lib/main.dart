import 'package:flutter/material.dart';
import 'menu.dart'; // NE PAS OUBLIER !

void main() => runApp(const ChessApp());

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true, // Optionnel, pour moderniser l’apparence
      ),
      home: const MenuPrincipal(), // ← LE MENU VIOLET ICI
    );
  }
}
