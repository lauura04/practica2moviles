// lib/screens/widgets/switch_selection_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import 'team_member_card.dart';

class SwitchSelectionWidget extends StatelessWidget {
  const SwitchSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final playerTeam = gameProvider.playerTeam;

    return Container(
      // Semi-transparent background
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueGrey),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Switch Pokémon",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 15),
              // List of team members
              ...playerTeam.map((pokemon) {
                // A Pokemon can only be switched in if it's not fainted AND not already in battle.
                final isFainted = pokemon.currentHealth <= 0;
                final isAlreadySelected = pokemon == gameProvider.selectedPokemon;
                final canBeSwitched = !isFainted && !isAlreadySelected;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    // Disable button if Pokemon is fainted or already active
                    onPressed: canBeSwitched
                        ? () => gameProvider.performVoluntarySwitch(pokemon)
                        : null,
                    child: Opacity(
                      opacity: canBeSwitched ? 1.0 : 0.5,
                      child: TeamMemberCard(pokemon: pokemon, isSelected: isAlreadySelected),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              // Cancel Button
              TextButton(
                onPressed: () => gameProvider.cancelSwitchSelection(),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
