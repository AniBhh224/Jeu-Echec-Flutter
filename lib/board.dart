import 'package:flutter/material.dart';
import 'pieces.dart';

class ChessBoard extends StatelessWidget {
  final List<List<ChessPiece?>> board;
  final List<List<bool>> casesPossibles;
  final void Function(int row, int col) onTapCase;

  const ChessBoard({
    super.key,
    required this.board,
    required this.casesPossibles,
    required this.onTapCase,
  });

  static const Color lightSquare = Color(0xFFEEEED2);
  static const Color darkSquare = Color(0xFF769656);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: 64,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;
          bool isLight = (row + col) % 2 == 0;

          return GestureDetector(
            onTap: () => onTapCase(row, col),
            child: Container(
              decoration: BoxDecoration(
                color: isLight ? lightSquare : darkSquare,
              ),
              child: Stack(
                children: [
                  if (casesPossibles[row][col])
                    Container(color: Colors.green.withOpacity(0.4)),
                  if (board[row][col] != null)
                    Center(child: board[row][col]!.buildImage(size: 44)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static List<List<ChessPiece?>> getInitialBoard() {
    final board = List.generate(8, (_) => List<ChessPiece?>.filled(8, null));

    for (int col = 0; col < 8; col++) {
      board[1][col] = ChessPiece(type: ChessPieceType.pawn, isWhite: false);
      board[6][col] = ChessPiece(type: ChessPieceType.pawn, isWhite: true);
    }

    board[0][0] = ChessPiece(type: ChessPieceType.rook, isWhite: false);
    board[0][1] = ChessPiece(type: ChessPieceType.knight, isWhite: false);
    board[0][2] = ChessPiece(type: ChessPieceType.bishop, isWhite: false);
    board[0][3] = ChessPiece(type: ChessPieceType.queen, isWhite: false);
    board[0][4] = ChessPiece(type: ChessPieceType.king, isWhite: false);
    board[0][5] = ChessPiece(type: ChessPieceType.bishop, isWhite: false);
    board[0][6] = ChessPiece(type: ChessPieceType.knight, isWhite: false);
    board[0][7] = ChessPiece(type: ChessPieceType.rook, isWhite: false);

    board[7][0] = ChessPiece(type: ChessPieceType.rook, isWhite: true);
    board[7][1] = ChessPiece(type: ChessPieceType.knight, isWhite: true);
    board[7][2] = ChessPiece(type: ChessPieceType.bishop, isWhite: true);
    board[7][3] = ChessPiece(type: ChessPieceType.queen, isWhite: true);
    board[7][4] = ChessPiece(type: ChessPieceType.king, isWhite: true);
    board[7][5] = ChessPiece(type: ChessPieceType.bishop, isWhite: true);
    board[7][6] = ChessPiece(type: ChessPieceType.knight, isWhite: true);
    board[7][7] = ChessPiece(type: ChessPieceType.rook, isWhite: true);

    return board;
  }
}
