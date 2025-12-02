// lib/screens/widgets/selection_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pokemon.dart';
import '../../providers/game_provider.dart';

class SelectionWidget extends StatelessWidget {
  const SelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    // UPDATED: Get the starter options now
    final List<Pokemon> starterOptions = gameProvider.starterPokemonOptions;

    return Center(
      key: const ValueKey('SelectionWidget'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Elige tu Pokémon inicial:", // UPDATED
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: starterOptions.map((pokemon) {
              return ElevatedButton(
                onPressed: () {
                  // UPDATED: Call the new function
                  gameProvider.selectStarterPokemon(pokemon);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(pokemon.name),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
