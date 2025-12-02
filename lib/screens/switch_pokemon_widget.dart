// lib/screens/widgets/switch_pokemon_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pokemon.dart';
import '../../providers/game_provider.dart';

class SwitchPokemonWidget extends StatelessWidget {
  const SwitchPokemonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    //Solo se ven los pokemon disponibles para pelear
    final availablePokemon = gameProvider.playerTeam
        .where((p) => p.currentHealth > 0)
        .toList();

    return Center(
      key: const ValueKey('SwitchPokemonWidget'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¡${gameProvider.selectedPokemon?.name} se debilitó!",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            "Elige tu siguiente Pokémon:",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 30),
          //Boton para cada pokemon disponible
          Wrap( //El wrap sirve para que los botones no se superpongan
            spacing: 10.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.center,
            children: availablePokemon.map((pokemon) {
              return ElevatedButton(
                onPressed: () {
                  gameProvider.performForcedSwitch(pokemon);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("${pokemon.name} (HP: ${pokemon.currentHealth})"),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
