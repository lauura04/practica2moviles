// lib/screens/widgets/team_member_card.dart

import 'package:flutter/material.dart';
import '../../models/pokemon.dart';

class TeamMemberCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isSelected;

  const TeamMemberCard({
    Key? key,
    required this.pokemon,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? Colors.blueGrey.shade700 //Superponer el pokemon seleccionado
          : Colors.grey.shade800,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [

            
            // const SizedBox(width: 10),
            
            // --- Pokémon Info ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${pokemon.name} (Lv: ${pokemon.level})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Health Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: pokemon.currentHealth / pokemon.maxHealth,
                      backgroundColor: Colors.red.shade900,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "HP: ${pokemon.currentHealth}/${pokemon.maxHealth}",
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
