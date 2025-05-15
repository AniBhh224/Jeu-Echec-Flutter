import 'package:flutter/material.dart';
import 'board.dart';
import 'pieces.dart';

class Jeu extends StatefulWidget {
  const Jeu({super.key});

  @override
  State<Jeu> createState() => _JeuState();
}

class _JeuState extends State<Jeu> {
  late List<List<ChessPiece?>> board;
  late List<List<bool>> casesPossibles;

  int? selectedRow;
  int? selectedCol;

  @override
  void initState() {
    super.initState();
    board = ChessBoard.getInitialBoard();
    casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));
  }

  void onTapCase(int row, int col) {
    ChessPiece? piece = board[row][col];

    if (selectedRow != null &&
        selectedCol != null &&
        casesPossibles[row][col]) {
      setState(() {
        ChessPiece movingPiece = board[selectedRow!][selectedCol!]!;
        board[row][col] = ChessPiece(
          type: movingPiece.type,
          isWhite: movingPiece.isWhite,
          initPos: false,
        );
        board[selectedRow!][selectedCol!] = null;

        selectedRow = null;
        selectedCol = null;
        casesPossibles =
            List.generate(8, (_) => List.generate(8, (_) => false));
      });
      return;
    }

    if (piece != null) {
      selectedRow = row;
      selectedCol = col;
      _calculerCasesPossibles(row, col);
    } else {
      selectedRow = null;
      selectedCol = null;
      setState(() {
        casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));
      });
    }
  }

  void _calculerCasesPossibles(int row, int col) {
    casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));
    ChessPiece? piece = board[row][col];
    if (piece == null) return;

    switch (piece.type) {
      case ChessPieceType.pawn:
        int dir = piece.isWhite ? -1 : 1;
        int next = row + dir;
        if (_inBounds(next, col) && board[next][col] == null) {
          casesPossibles[next][col] = true;
          int two = row + 2 * dir;
          if (piece.initPos && _inBounds(two, col) && board[two][col] == null) {
            casesPossibles[two][col] = true;
          }
        }
        for (int dc in [-1, 1]) {
          int nc = col + dc;
          if (_inBounds(next, nc) &&
              board[next][nc] != null &&
              board[next][nc]!.isWhite != piece.isWhite) {
            casesPossibles[next][nc] = true;
          }
        }
        break;

      case ChessPieceType.knight:
        for (var m in [
          [-2, -1], [-2, 1], [-1, -2], [-1, 2],
          [1, -2], [1, 2], [2, -1], [2, 1]
        ]) {
          int r = row + m[0], c = col + m[1];
          if (_inBounds(r, c) &&
              (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite)) {
            casesPossibles[r][c] = true;
          }
        }
        break;

      case ChessPieceType.bishop:
        _calculerDirectionnel(row, col, piece.isWhite, diagonals: true);
        break;

      case ChessPieceType.rook:
        _calculerDirectionnel(row, col, piece.isWhite, straight: true);
        break;

      case ChessPieceType.queen:
        _calculerDirectionnel(row, col, piece.isWhite,
            straight: true, diagonals: true);
        break;

      case ChessPieceType.king:
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            int r = row + dr, c = col + dc;
            if (_inBounds(r, c) &&
                (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite)) {
              casesPossibles[r][c] = true;
            }
          }
        }
        break;
    }

    setState(() {});
  }

  void _calculerDirectionnel(int row, int col, bool isWhite,
      {bool straight = false, bool diagonals = false}) {
    List<List<int>> directions = [];
    if (straight) directions += [[-1, 0], [1, 0], [0, -1], [0, 1]];
    if (diagonals) directions += [[-1, -1], [-1, 1], [1, -1], [1, 1]];

    for (var dir in directions) {
      int r = row + dir[0], c = col + dir[1];
      while (_inBounds(r, c)) {
        if (board[r][c] == null) {
          casesPossibles[r][c] = true;
        } else {
          if (board[r][c]!.isWhite != isWhite) {
            casesPossibles[r][c] = true;
          }
          break;
        }
        r += dir[0];
        c += dir[1];
      }
    }
  }

  bool _inBounds(int row, int col) => row >= 0 && row < 8 && col >= 0 && col < 8;

  @override
  Widget build(BuildContext context) {
    return ChessBoard(
      board: board,
      casesPossibles: casesPossibles,
      onTapCase: onTapCase,
    );
  }
}
