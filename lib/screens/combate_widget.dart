// lib/screens/widgets/combat_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import 'team_member_card.dart';
import 'heal_selection_widget.dart';
import 'switch_selection_widget.dart';

class CombatWidget extends StatelessWidget {
  const CombatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final activePokemon = gameProvider.selectedPokemon!;
        final enemy = gameProvider.currentEnemy!;
        final isProcessing = gameProvider.isTurnProcessing;
        final isTeamFull = gameProvider.playerTeam.length >= 6;
        final playerTeam = gameProvider.playerTeam;

        // Se puede cambiar de Pokémon si hay al menos uno más en el equipo que no esté debilitado
        final canSwitch = playerTeam.any((p) => p != activePokemon && p.currentHealth > 0);

        return Stack(
          children: [
            // Vista principal del combate (panel de equipo a la izquierda, arena a la derecha)
            Row(
              children: [
                // --- COLUMNA IZQUIERDA: EQUIPO DEL JUGADOR ---
                Container(
                  width: 180,
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Team",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      const Divider(color: Colors.white54),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: playerTeam.length,
                          itemBuilder: (context, index) {
                            final pokemon = playerTeam[index];
                            return TeamMemberCard(
                              pokemon: pokemon,
                              isSelected: pokemon == activePokemon,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // --- COLUMNA DERECHA: ARENA DE COMBATE ---
                Expanded(
                  child: Padding(
                    key: const ValueKey('CombatWidget'),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Información de los combatientes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${activePokemon.name}\nLv: ${activePokemon.level}\nHealth: ${activePokemon.currentHealth}/${activePokemon.maxHealth}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                            Text(
                              "${enemy.name}\nLv: ${enemy.level}\nHealth: ${enemy.currentHealth}/${enemy.maxHealth}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ],
                        ),
                        // Log de combate
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            gameProvider.combatLog,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white70),
                          ),
                        ),
                        // Botones de acción principales
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: isProcessing ? null : () => gameProvider.performCombatAction('attack'),
                              child: const Text("Attack"),
                            ),
                            ElevatedButton(
                              onPressed: isProcessing ? null : () => gameProvider.performCombatAction('heal'),
                              child: const Text("Heal"),
                            ),
                            ElevatedButton(
                              onPressed: (isProcessing || !canSwitch) ? null : () => gameProvider.performCombatAction('switch'),
                              child: const Text("Switch"),
                            ),
                          ],
                        ),
                        // Botón de "Befriend" en una fila separada
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                            onPressed: (isProcessing || isTeamFull) ? null : () => gameProvider.performCombatAction('befriend'),
                            child: const Text("Befriend"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- SUPERPOSICIONES (OVERLAYS) ---
            // Pantalla de selección de curación
            if (gameProvider.gameScreen == GameScreen.selectingHealTarget)
              const HealSelectionWidget(),

            // Pantalla de selección de cambio
            if (gameProvider.gameScreen == GameScreen.selectingSwitchTarget)
              const SwitchSelectionWidget(),
          ],
        );
      },
    );
  }
}
