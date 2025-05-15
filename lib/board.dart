import 'package:flutter/material.dart';
import 'pieces.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  static const int boardSize = 8;
  static const Color lightSquare = Color(0xFFEEEED2);
  static const Color darkSquare = Color(0xFF769656);

  late List<List<ChessPiece?>> board;
  late List<List<bool>> casesPossibles;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    board = List.generate(8, (_) => List.generate(8, (_) => null));
    casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));

    // Pions noirs
    for (int col = 0; col < 8; col++) {
      board[1][col] = ChessPiece(type: ChessPieceType.pawn, isWhite: false);
    }

    // Pions blancs
    for (int col = 0; col < 8; col++) {
      board[6][col] = ChessPiece(type: ChessPieceType.pawn, isWhite: true);
    }

    // Pièces noires
    board[0] = [
      ChessPiece(type: ChessPieceType.rook, isWhite: false),
      ChessPiece(type: ChessPieceType.knight, isWhite: false),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false),
      ChessPiece(type: ChessPieceType.queen, isWhite: false),
      ChessPiece(type: ChessPieceType.king, isWhite: false),
      ChessPiece(type: ChessPieceType.bishop, isWhite: false),
      ChessPiece(type: ChessPieceType.knight, isWhite: false),
      ChessPiece(type: ChessPieceType.rook, isWhite: false),
    ];

    // Pièces blanches
    board[7] = [
      ChessPiece(type: ChessPieceType.rook, isWhite: true),
      ChessPiece(type: ChessPieceType.knight, isWhite: true),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true),
      ChessPiece(type: ChessPieceType.queen, isWhite: true),
      ChessPiece(type: ChessPieceType.king, isWhite: true),
      ChessPiece(type: ChessPieceType.bishop, isWhite: true),
      ChessPiece(type: ChessPieceType.knight, isWhite: true),
      ChessPiece(type: ChessPieceType.rook, isWhite: true),
    ];
  }
  void calcul_lateral(int, row, int col){
    casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));

  }
  void calcul_diag(int, row, int col){

  }
  void calcul_case_possible(int row, int col) {
    ChessPiece? piece = board[row][col];

    // Réinitialiser les cases possibles
    casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));

    if (piece == null) return;

    if (piece.type == ChessPieceType.pawn) {
      int direction = piece.isWhite ? -1 : 1;

      int nextRow = row + direction;
      if (_inBounds(nextRow, col) && board[nextRow][col] == null) {
        casesPossibles[nextRow][col] = true;

        int nextNextRow = row + 2 * direction;
        if (piece.initPos &&
            _inBounds(nextNextRow, col) &&
            board[nextNextRow][col] == null) {
          casesPossibles[nextNextRow][col] = true;
        }
      }

      for (int deltaCol in [-1, 1]) {
        int diagCol = col + deltaCol;
        if (_inBounds(nextRow, diagCol) &&
            board[nextRow][diagCol] != null &&
            board[nextRow][diagCol]!.isWhite != piece.isWhite) {
          casesPossibles[nextRow][diagCol] = true;
        }
      }
    }
  else if(piece.type == ChessPieceType.knight){

    }
  else if(piece.type == ChessPieceType.bishop){
    #utiliser calcul diag
    }
    setState(() {});
  }

  bool _inBounds(int row, int col) => row >= 0 && row < 8 && col >= 0 && col < 8;

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

          return GestureDetector(
            onTap: () => calcul_case_possible(row, col),
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
}
