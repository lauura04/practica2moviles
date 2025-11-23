// lib/screens/widgets/game_over_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final pokemon = gameProvider.selectedPokemon!; // UPDATED
    final enemy = gameProvider.currentEnemy!;     // UPDATED

    String finalMessage = pokemon.currentHealth > 0 ? "You have won!" : "You have been defeated..."; // UPDATED
    if (enemy.isAlly) {
      finalMessage = "New ally acquired!";
    }

    return Center(
      key: const ValueKey('GameOverWidget'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            finalMessage,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => gameProvider.restartGame(),
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }
}
