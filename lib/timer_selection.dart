import 'package:flutter/material.dart';
import 'jeu.dart';
import 'player_type.dart';
import 'menu.dart';

class TimerSelectionPage extends StatefulWidget {
  const TimerSelectionPage({super.key});

  @override
  State<TimerSelectionPage> createState() => _TimerSelectionPageState();
}

class _TimerSelectionPageState extends State<TimerSelectionPage> {
  final TextEditingController _controllerBlanc = TextEditingController();
  final TextEditingController _controllerNoir = TextEditingController();

  final List<int> durations = [5, 10, 15, 20, 30, 60];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      appBar: AppBar(
        title: const Text("Choisir la durée et les noms"),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MenuPrincipal()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nom joueur blanc",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _controllerBlanc,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF7B1FA2)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Nom joueur noir",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _controllerNoir,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF7B1FA2)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Durée de la partie :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: durations.length,
                itemBuilder: (_, index) {
                  final minutes = durations[index];
                  return ListTile(
                    title: Text("$minutes minutes"),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Jeu(
                            joueurBlancType: PlayerType.human,
                            joueurNoirType: PlayerType.human,
                            niveauBot: 0,
                            duration: Duration(minutes: minutes),
                            nomJoueurBlanc: _controllerBlanc.text.isEmpty ? "Blanc" : _controllerBlanc.text,
                            nomJoueurNoir: _controllerNoir.text.isEmpty ? "Noir" : _controllerNoir.text,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
