import 'package:flutter/material.dart';
import 'jeu.dart';
import 'player_type.dart';



class MenuBot extends StatefulWidget {
  const MenuBot({super.key});

  @override
  State<MenuBot> createState() => _MenuBotState();
}

class _MenuBotState extends State<MenuBot> {
  int niveauBot = 5;
  bool joueBlanc = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuration du Bot")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Choisissez le niveau du bot",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: niveauBot.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: niveauBot.toString(),
              onChanged: (val) {
                setState(() {
                  niveauBot = val.round();
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Avec quelle couleur voulez-vous jouer ?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text("Blanc"),
              leading: Radio<bool>(
                value: true,
                groupValue: joueBlanc,
                onChanged: (val) {
                  setState(() {
                    joueBlanc = val!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Noir"),
              leading: Radio<bool>(
                value: false,
                groupValue: joueBlanc,
                onChanged: (val) {
                  setState(() {
                    joueBlanc = val!;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Jeu(
                      joueurBlancType: joueBlanc ? PlayerType.human : PlayerType.bot,
                      joueurNoirType: joueBlanc ? PlayerType.bot : PlayerType.human,
                      isBoardReversed: !joueBlanc, // inversé si joueur humain est noir
                    ),
                  ),
                );
              },
              child: const Text("Jouer"),
            ),
          ],
        ),
      ),
    );
  }
}
