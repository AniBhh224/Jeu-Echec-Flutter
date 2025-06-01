import 'package:flutter/material.dart';
import 'package:stockfish/stockfish.dart';
import 'board.dart';
import 'pieces.dart';
import 'joueur.dart';
import 'utils.dart';
import 'menu.dart';
import 'player_type.dart';




class Jeu extends StatefulWidget {

  final PlayerType joueurBlancType;
  final PlayerType joueurNoirType;
  final bool isBoardReversed; // <-- Ajouté
  final int niveauBot; // ajoute ce paramètre

  const Jeu({
    super.key,
    this.joueurBlancType = PlayerType.human,
    this.joueurNoirType = PlayerType.human,
    this.isBoardReversed = false,
    this.niveauBot = 0, // valeur par défaut (niveau minimal)

  });

  @override
  State<Jeu> createState() => _JeuState();
}

class BandeJoueur extends StatelessWidget {
  final bool estBlanc;
  final bool actif;
  final String nom;

  const BandeJoueur({
    super.key,
    required this.estBlanc,
    required this.nom,
    required this.actif,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFE7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: actif ? const Color(0xFF8E24AA) : Colors.transparent,
          width: 3
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            child: Image.asset(
              estBlanc ? 'assets/images/wp.png' : 'assets/images/bp.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 10),
          Text(
            nom,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}



class _JeuState extends State<Jeu> {

  bool estInverse = false; // par défaut pas inversé

  late List<List<ChessPiece?>> board;
  late List<List<bool>> casesPossibles;
  late bool isBoardReversed;

  PlayerType joueurBlancType = PlayerType.bot;
  PlayerType joueurNoirType = PlayerType.human; // exemple : bot joue noir

  late Stockfish stockfish;
  bool isBotThinking = false;

  int? selectedRow;
  int? selectedCol;

  late Joueur joueurBlanc;
  late Joueur joueurNoir;
  late Joueur joueurActuel;
  late int niveauBot;

  @override
  void initState() {
    super.initState();

    niveauBot = widget.niveauBot;

    board = ChessBoard.getInitialBoard();
    casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));
    joueurBlanc = const Joueur(nom: 'Blanc', estBlanc: true);
    joueurNoir = const Joueur(nom: 'Noir', estBlanc: false);
    joueurActuel = joueurBlanc;

    joueurBlancType = widget.joueurBlancType;
    joueurNoirType = widget.joueurNoirType;

    print('DEBUG INIT: Bot blanc ? ${joueurBlancType == PlayerType.bot}');
    print('DEBUG INIT: Bot noir ? ${joueurNoirType == PlayerType.bot}');
    print('DEBUG INIT: Joueur actuel : ${joueurActuel.nom}');
    print('DEBUG INIT: Est bot turn ? ${_isBotTurn()}');

    stockfish = Stockfish();

    stockfish.stdout.listen((event) {
      if (event.contains('bestmove') && isBotThinking) {
        final moveStr = event.split(' ')[1];
        _jouerCoupDepuisString(moveStr);
        isBotThinking = false;
      }
    });

    stockfish.state.addListener(() {
      print('DEBUG: Stockfish state changed: ${stockfish.state.value}');
      if (stockfish.state.value == StockfishState.ready && _isBotTurn()) {
        print('DEBUG: Moteur prêt et bot doit jouer son coup...');
        _demanderCoupStockfish();
      }
    });

    isBoardReversed = widget.isBoardReversed;
  }

  bool _isBotTurn() {
    return (joueurActuel == joueurBlanc && joueurBlancType == PlayerType.bot) ||
        (joueurActuel == joueurNoir && joueurNoirType == PlayerType.bot);
  }


  Future<void> _demanderCoupStockfish() async {
    if (isBotThinking) return;
    isBotThinking = true;

    // Configure le niveau du bot
    stockfish.stdin = 'setoption name Skill Level value $niveauBot';

    final fen = toFEN(board, isWhiteTurn: joueurActuel.estBlanc);
    stockfish.stdin = 'position fen $fen';
    stockfish.stdin = 'go movetime 1000';
  }

  /// Change le joueur actif et lance le bot si c’est son tour
  void _switchPlayer() {
    if (joueurActuel == joueurBlanc) {
      joueurActuel = joueurNoir;
    } else {
      joueurActuel = joueurBlanc;
    }

    // Inverse l'affichage seulement si les deux joueurs sont humains
    if (joueurBlancType == PlayerType.human && joueurNoirType == PlayerType.human) {
      estInverse = !estInverse;
    }
  }


  void _jouerCoupDepuisString(String move) {

    if (move.length < 4) return;

    // Calcul positions
    int startCol = move.codeUnitAt(0) - 'a'.codeUnitAt(0);
    int startRow = 8 - int.parse(move[1]);
    int endCol = move.codeUnitAt(2) - 'a'.codeUnitAt(0);
    int endRow = 8 - int.parse(move[3]);

    setState(() {
      board[endRow][endCol] = board[startRow][startCol];
      board[startRow][startCol] = null;

      // Switch player ici, AVANT d'appeler le bot
      _switchPlayer();

      selectedRow = null;
      selectedCol = null;
      casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));
    });

    isBotThinking = false; // le bot a fini de jouer

    if (_isBotTurn()) {
      _demanderCoupStockfish();
    }
    print('Couleur pion déplacé: ${board[startRow][startCol]?.isWhite}');

  }

  void onTapCase(int row, int col) {
    ChessPiece? piece = board[row][col];

    if (selectedRow != null &&
        selectedCol != null &&
        casesPossibles[row][col]) {
      setState(() {
        ChessPiece movingPiece = board[selectedRow!][selectedCol!]!;
        bool estRoque = movingPiece.type == ChessPieceType.king &&
            (col - selectedCol!).abs() == 2;

        board[row][col] = ChessPiece(
          type: movingPiece.type,
          isWhite: movingPiece.isWhite,
          initPos: false,
        );
        board[selectedRow!][selectedCol!] = null;

        if (estRoque) {
          if (col > selectedCol!) {
            // Petit roque
            board[row][col - 1] = board[row][7];
            board[row][7] = null;
          } else {
            // Grand roque
            board[row][col + 1] = board[row][0];
            board[row][0] = null;
          }
        }

        selectedRow = null;
        selectedCol = null;
        casesPossibles = List.generate(8, (_) => List.generate(8, (_) => false));
        joueurActuel = (joueurActuel == joueurBlanc) ? joueurNoir : joueurBlanc;
      });

      verifierPromotion(row, col);

      // Si c'est le tour du bot, on demande un coup après la promotion
      if (_isBotTurn()) {
        _demanderCoupStockfish();
      }

      return;
    }

    if (piece != null && piece.isWhite == joueurActuel.estBlanc) {
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

  Future<void> verifierPromotion(int row, int col) async {
    final piece = board[row][col];
    if (piece == null || piece.type != ChessPieceType.pawn) return;

    if ((piece.isWhite && row == 0) || (!piece.isWhite && row == 7)) {
      final typeChoisi = await afficherChoixPromotion(piece.isWhite);
      if (typeChoisi != null) {
        setState(() {
          board[row][col] = ChessPiece(
            type: typeChoisi,
            isWhite: piece.isWhite,
            initPos: false,
          );
        });
      }
    }
  }

  Future<ChessPieceType?> afficherChoixPromotion(bool isWhite) async {
    return showDialog<ChessPieceType>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Promotion : choisissez une pièce'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var type in [
              ChessPieceType.queen,
              ChessPieceType.rook,
              ChessPieceType.bishop,
              ChessPieceType.knight,
            ])
              GestureDetector(
                onTap: () => Navigator.of(context).pop(type),
                child: ChessPiece(type: type, isWhite: isWhite).buildImage(size: 50),
              ),
          ],
        ),
      ),
    );
  }

  void _calculerCasesPossibles(int row, int col) {
    ChessPiece? piece = board[row][col];
    if (piece == null) return;

    casesPossibles = _getCoupsPotentielsDepuis(row, col);

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (casesPossibles[r][c]) {
          final backup = board[r][c];
          board[r][c] = board[row][col];
          board[row][col] = null;

          if (kingIsChecked(piece.isWhite)) {
            casesPossibles[r][c] = false;
          }

          board[row][col] = board[r][c];
          board[r][c] = backup;
        }
      }
    }

    setState(() {});
  }

  List<List<bool>> _getCoupsPotentielsDepuis(int row, int col, {bool ignorerRoque = false}) {
    List<List<bool>> coups = List.generate(8, (_) => List.generate(8, (_) => false));
    ChessPiece? piece = board[row][col];
    if (piece == null) return coups;

    bool isWhite = piece.isWhite;

    switch (piece.type) {
      case ChessPieceType.pawn:
        int dir = isWhite ? -1 : 1;
        int next = row + dir;
        if (_inBounds(next, col) && board[next][col] == null) {
          coups[next][col] = true;
          int two = row + 2 * dir;
          if (piece.initPos && _inBounds(two, col) && board[two][col] == null) {
            coups[two][col] = true;
          }
        }
        for (int dc in [-1, 1]) {
          int nc = col + dc;
          if (_inBounds(next, nc) &&
              board[next][nc] != null &&
              board[next][nc]!.isWhite != isWhite) {
            coups[next][nc] = true;
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
              (board[r][c] == null || board[r][c]!.isWhite != isWhite)) {
            coups[r][c] = true;
          }
        }
        break;

      case ChessPieceType.bishop:
        _remplirDirectionnel(coups, row, col, isWhite, diagonals: true);
        break;

      case ChessPieceType.rook:
        _remplirDirectionnel(coups, row, col, isWhite, straight: true);
        break;

      case ChessPieceType.queen:
        _remplirDirectionnel(coups, row, col, isWhite, straight: true, diagonals: true);
        break;

      case ChessPieceType.king:
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            int r = row + dr, c = col + dc;
            if (_inBounds(r, c) &&
                (board[r][c] == null || board[r][c]!.isWhite != isWhite)) {
              coups[r][c] = true;
            }
          }
        }

        if (!ignorerRoque && piece.initPos && !kingIsChecked(isWhite)) {
          if (_canCastle(isWhite, kingSide: true)) coups[row][col + 2] = true;
          if (_canCastle(isWhite, kingSide: false)) coups[row][col - 2] = true;
        }
        break;
    }

    return coups;
  }

  bool _canCastle(bool isWhite, {required bool kingSide}) {
    int row = isWhite ? 7 : 0;
    int colKing = 4;
    int colRook = kingSide ? 7 : 0;
    int dir = kingSide ? 1 : -1;

    ChessPiece? king = board[row][colKing];
    ChessPiece? rook = board[row][colRook];

    if (king == null || rook == null) return false;
    if (king.type != ChessPieceType.king || rook.type != ChessPieceType.rook) return false;
    if (!king.initPos || !rook.initPos) return false;

    int start = kingSide ? 5 : 1;
    int end = kingSide ? 6 : 3;
    for (int c = start; c <= end; c++) {
      if (board[row][c] != null) return false;
    }

    for (int i = 0; i <= 2; i++) {
      int c = colKing + dir * i;
      if (_caseSousMenace(row, c, !isWhite)) return false;
    }

    return true;
  }

  bool _caseSousMenace(int row, int col, bool parCouleurBlanche) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece != null && piece.isWhite == parCouleurBlanche) {
          final attaques = _getCoupsPotentielsDepuis(r, c, ignorerRoque: true);
          if (attaques[row][col]) return true;
        }
      }
    }
    return false;
  }

  void _remplirDirectionnel(
      List<List<bool>> cible,
      int row,
      int col,
      bool isWhite, {
        bool straight = false,
        bool diagonals = false,
      }) {
    List<List<int>> directions = [];
    if (straight) directions += [[-1, 0], [1, 0], [0, -1], [0, 1]];
    if (diagonals) directions += [[-1, -1], [-1, 1], [1, -1], [1, 1]];

    for (var dir in directions) {
      int r = row + dir[0], c = col + dir[1];
      while (_inBounds(r, c)) {
        if (board[r][c] == null) {
          cible[r][c] = true;
        } else {
          if (board[r][c]!.isWhite != isWhite) {
            cible[r][c] = true;
          }
          break;
        }
        r += dir[0];
        c += dir[1];
      }
    }
  }

  bool kingIsChecked(bool estBlanc) {
    int? kr, kc;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece != null &&
            piece.type == ChessPieceType.king &&
            piece.isWhite == estBlanc) {
          kr = r;
          kc = c;
          break;
        }
      }
    }

    if (kr == null || kc == null) return false;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece != null && piece.isWhite != estBlanc) {
          final attaques = _getCoupsPotentielsDepuis(r, c, ignorerRoque: true);
          if (attaques[kr][kc]) return true;
        }
      }
    }

    return false;
  }

  bool _inBounds(int row, int col) => row >= 0 && row < 8 && col >= 0 && col < 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFE7), // Fond violet clair
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BandeJoueur(
                    estBlanc: true,
                    nom: joueurBlanc.nom,
                    actif: joueurActuel == joueurBlanc,
                  ),
                  BandeJoueur(
                    estBlanc: false,
                    nom: joueurNoir.nom,
                    actif: joueurActuel == joueurNoir,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: Center(
                  child: ChessBoard(
                    board: board,
                    casesPossibles: casesPossibles,
                    onTapCase: onTapCase,
                    reverse: isBoardReversed,
                  ),


                ),
              ),

              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MenuPrincipal()),
                          (route) => false,
                    );
                  },
                  child: Image.asset(
                    'assets/images/home.png',
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
