import 'pieces.dart'; // Assure-toi d'importer la classe ChessPiece

String toFEN(List<List<ChessPiece?>> board, {required bool isWhiteTurn}) {
  StringBuffer fen = StringBuffer();

  for (int row = 0; row < 8; row++) {
    int emptyCount = 0;
    for (int col = 0; col < 8; col++) {
      final piece = board[row][col];
      if (piece == null) {
        emptyCount++;
      } else {
        if (emptyCount > 0) {
          fen.write(emptyCount);
          emptyCount = 0;
        }
        fen.write(_pieceToFENChar(piece));
      }
    }
    if (emptyCount > 0) {
      fen.write(emptyCount);
    }
    if (row != 7) {
      fen.write('/');
    }
  }

  // Ajoute les infos supplémentaires :
  // tour (w ou b), roques possibles, prise en passant, etc.
  fen.write(isWhiteTurn ? ' w ' : ' b ');

  fen.write('KQkq - 0 1'); // tu peux adapter ces infos si besoin

  return fen.toString();
}

String _pieceToFENChar(ChessPiece piece) {
  String c = switch (piece.type) {
    ChessPieceType.pawn => 'p',
    ChessPieceType.knight => 'n',
    ChessPieceType.bishop => 'b',
    ChessPieceType.rook => 'r',
    ChessPieceType.queen => 'q',
    ChessPieceType.king => 'k',
  };
  return piece.isWhite ? c.toUpperCase() : c;
}
