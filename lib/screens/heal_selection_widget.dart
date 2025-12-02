// lib/screens/widgets/heal_selection_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import 'team_member_card.dart';

class HealSelectionWidget extends StatelessWidget {
  const HealSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final playerTeam = gameProvider.playerTeam;

    return Container(
      // Semi-transparent background to show it's an overlay
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
                "Select Pokémon to Heal",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 15),
              // List of team members
              ...playerTeam.map((pokemon) {
                // A Pokemon can only be healed if it's not at max health
                final canBeHealed = pokemon.currentHealth < pokemon.maxHealth;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // Let the card handle padding
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    // Disable button if Pokemon has full health
                    onPressed: canBeHealed
                        ? () => gameProvider.healPokemon(pokemon)
                        : null,
                    child: Opacity(
                      opacity: canBeHealed ? 1.0 : 0.5,
                      child: TeamMemberCard(pokemon: pokemon),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              // Cancel Button
              TextButton(
                onPressed: () => gameProvider.cancelHealSelection(),
                child: const Text("Cancelar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
