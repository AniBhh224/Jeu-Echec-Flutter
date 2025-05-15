import 'package:flutter/material.dart';

enum ChessPieceType { pawn, knight, bishop, rook, queen, king }

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final bool initPos;

  const ChessPiece({
    required this.type,
    required this.isWhite,
    this.initPos = true,
  });

  String get imagePath {
    final color = isWhite ? 'w' : 'b';
    final piece = switch (type) {
      ChessPieceType.pawn => 'p',
      ChessPieceType.knight => 'n',
      ChessPieceType.bishop => 'b',
      ChessPieceType.rook => 'r',
      ChessPieceType.queen => 'q',
      ChessPieceType.king => 'k',
    };
    return 'assets/images/$color$piece.png';
  }

  Widget buildImage({double size = 40}) {
    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
