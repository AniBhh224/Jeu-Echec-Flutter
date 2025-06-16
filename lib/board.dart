import 'package:flutter/material.dart';
import 'pieces.dart';

class ChessBoard extends StatelessWidget {
  final List<List<ChessPiece?>> board;
  final List<List<bool>> casesPossibles;
  final void Function(int row, int col) onTapCase;
  final bool reverse;

  const ChessBoard({
    super.key,
    required this.board,
    required this.casesPossibles,
    required this.onTapCase,
    this.reverse = false,
  });

  static const Color lightSquare = Color(0xFFF3EFE7);
  static const Color darkSquare = Color(0xFF8E24AA);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double boardSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        final double caseSize = boardSize / 8;

        return Center(
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: Column(
              children: List.generate(8, (row) {
                int displayRow = reverse ? 7 - row : row;
                return Row(
                  children: List.generate(8, (col) {
                    int displayCol = reverse ? 7 - col : col;
                    bool isLight = (displayRow + displayCol) % 2 == 0;

                    return GestureDetector(
                      onTap: () => onTapCase(displayRow, displayCol),
                      child: Container(
                        width: caseSize,
                        height: caseSize,
                        decoration: BoxDecoration(
                          color: isLight ? lightSquare : darkSquare,
                        ),
                        child: Stack(
                          children: [
                            if (casesPossibles[displayRow][displayCol])
                              Container(
  decoration: BoxDecoration(
    color: Colors.amberAccent.withOpacity(0.5),
    border: Border.all(color: Colors.black, width: 2),
    borderRadius: BorderRadius.circular(6),
  ),
),
                            if (board[displayRow][displayCol] != null)
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: board[displayRow][displayCol]!
                                      .buildImage(size: caseSize * 0.88),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        );
      },
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
