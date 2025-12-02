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
      //Fondo semitransparente
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
              //Lista del equipo
              ...playerTeam.map((pokemon) {
                //Solo se puede curar si no esta max vida
                final canBeHealed = pokemon.currentHealth < pokemon.maxHealth;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    //Desactiva el boton si el Pokemon esta full vida
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
