// lib/screens/widgets/game_won_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class GameWonWidget extends StatelessWidget {
  const GameWonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('GameWonWidget'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¡Felicidades!",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            "Has derrotado a todos los enemigos.",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Provider.of<GameProvider>(context, listen: false).restartGame(),
            child: const Text("Jugar de Nuevo"),
          )
        ],
      ),
    );
  }
}
