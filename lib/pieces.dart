import 'package:flutter/material.dart';

/// Enum pour les types de pièces
enum ChessPieceType { pawn, knight, bishop, rook, queen, king }

/// Classe représentant une pièce d'échecs
class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final bool initPos;
  ChessPiece({
    required this.type,
    required this.isWhite,
    this.initPos = true
  });

  /// Renvoie le chemin de l'image correspondant à la pièce
  String get imagePath {
    final colorPrefix = isWhite ? 'w' : 'b'; // w = white, b = black
    final typeSuffix = switch (type) {
      ChessPieceType.pawn => 'p',
      ChessPieceType.knight => 'n',
      ChessPieceType.bishop => 'b',
      ChessPieceType.rook => 'r',
      ChessPieceType.queen => 'q',
      ChessPieceType.king => 'k',
    };
    return 'assets/images/$colorPrefix$typeSuffix.png';
  }

  /// Renvoie le widget Image de la pièce
  Widget buildImage({double size = 40}) {
    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
