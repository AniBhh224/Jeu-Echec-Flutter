import 'package:flutter/material.dart';
import 'jeu.dart';
import 'pieces.dart'; // pour PlayerType

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // Fond violet très clair
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 400,
                ),
              ),

              const SizedBox(height: 50),

              // Bouton "Joueur seul" (Humain blanc vs Bot noir)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B1FA2), // Violet foncé
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Jeu(
                          joueurBlancType: PlayerType.human,
                          joueurNoirType: PlayerType.bot,
                        ),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Joueur seul',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Bouton "2 joueurs" (Humain blanc vs Humain noir)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: const BorderSide(color: Color(0xFF6A1B9A), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Jeu(
                          joueurBlancType: PlayerType.human,
                          joueurNoirType: PlayerType.human,
                        ),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      '2 joueurs',
                      style: TextStyle(color: Color(0xFF6A1B9A), fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
