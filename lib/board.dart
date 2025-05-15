import 'package:flutter/material.dart';
import 'pieces.dart'; // Classe ChessPiece

class ChessBoard extends StatelessWidget {
  static const int boardSize = 8;
  static const Color lightSquare = Color(0xFFEEEED2);
  static const Color darkSquare = Color(0xFF769656);

  // Plateau avec les pièces dans la position de départ
  final List<List<ChessPiece?>> board = [
    // Ligne 0 : pièces noires
    [
      ChessPiece(type: ChessPieceType.rook, isWhite: false),
      ChessPiece(type: ChessPieceType.knight, isWhite: false),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false),
      ChessPiece(type: ChessPieceType.queen, isWhite: false),
      ChessPiece(type: ChessPieceType.king, isWhite: false),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false),
      ChessPiece(type: ChessPieceType.knight, isWhite: false),
      ChessPiece(type: ChessPieceType.rook, isWhite: false),
    ],
    // Ligne 1 : pions noirs
    List.generate(8, (_) => ChessPiece(type: ChessPieceType.pawn, isWhite: false)),

    // Lignes 2 à 5 : vides
    List.generate(8, (_) => null),
    List.generate(8, (_) => null),
    List.generate(8, (_) => null),
    List.generate(8, (_) => null),

    // Ligne 6 : pions blancs
    List.generate(8, (_) => ChessPiece(type: ChessPieceType.pawn, isWhite: true)),

    // Ligne 7 : pièces blanches
    [
      ChessPiece(type: ChessPieceType.rook, isWhite: true),
      ChessPiece(type: ChessPieceType.knight, isWhite: true),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true),
      ChessPiece(type: ChessPieceType.queen, isWhite: true),
      ChessPiece(type: ChessPieceType.king, isWhite: true),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true),
      ChessPiece(type: ChessPieceType.knight, isWhite: true),
      ChessPiece(type: ChessPieceType.rook, isWhite: true),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: boardSize * boardSize,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boardSize,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int row = index ~/ boardSize;
          int col = index % boardSize;
          bool isLight = (row + col) % 2 == 0;

          return Container(
            decoration: BoxDecoration(
              color: isLight ? lightSquare : darkSquare,
            ),
            child: Center(
              child: board[row][col]?.buildImage(size: 44),
            ),
          );
        },
      ),
    );
  }
}
