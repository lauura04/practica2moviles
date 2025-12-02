// lib/screens/widgets/combat_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import 'team_member_card.dart';
import 'heal_selection_widget.dart';
import 'switch_selection_widget.dart';
import 'question_widget.dart';

class CombatWidget extends StatelessWidget {
  const CombatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final activePokemon = gameProvider.selectedPokemon!;
        final currentEnemy = gameProvider.currentEnemy!;
        final isProcessing = gameProvider.isTurnProcessing;
        final isTeamFull = gameProvider.playerTeam.length >= 6;
        final playerTeam = gameProvider.playerTeam;
        final canSwitch = playerTeam.any((p) => p != activePokemon && p.currentHealth > 0);

        // NEW: Get the next enemy using the new getter
        final nextEnemy = gameProvider.nextEnemy;

        return Stack(
          children: [
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
                        "Tu Equipo",
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
                        // --- IMÁGENES DE COMBATIENTES ---
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Pokémon del Jugador (BACK)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    activePokemon.backImageAsset,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${activePokemon.name}\nLv: ${activePokemon.level}\nHealth: ${activePokemon.currentHealth}/${activePokemon.maxHealth}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16, height: 1.4),
                                  ),
                                ],
                              ),
                              // Pokémon Enemigo (FRONT)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${currentEnemy.name}\nLv: ${currentEnemy.level}\nHP: ${currentEnemy.currentHealth}/${currentEnemy.maxHealth}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.orangeAccent),
                                  ),
                                  const SizedBox(height: 10),
                                  Image.asset(
                                    currentEnemy.imageAsset,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                  // Next enemy preview
                                  if (nextEnemy != null) ...[
                                    const SizedBox(height: 10),
                                    Opacity(
                                      opacity: 0.7,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.white30, width: 1),
                                        ),
                                        child: Text(
                                          "Siguiente: ${nextEnemy.name}",
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Log de combate
                        Container(
                          padding: const EdgeInsets.all(12),
                          height: 80, // Fixed height for log
                          child: SingleChildScrollView(
                            child: Text(
                              gameProvider.combatLog,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white70),
                            ),
                          ),
                        ),

                        // Botones de acción
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: isProcessing ? null : () => gameProvider.performCombatAction('attack'),
                                  child: const Text("Atacar"),
                                ),
                                ElevatedButton(
                                  onPressed: isProcessing ? null : () => gameProvider.performCombatAction('heal'),
                                  child: const Text("Curarse"),
                                ),
                                ElevatedButton(
                                  onPressed: (isProcessing || !canSwitch) ? null : () => gameProvider.performCombatAction('switch'),
                                  child: const Text("Cambiar"),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
                                onPressed: (isProcessing || isTeamFull) ? null : () => gameProvider.performCombatAction('befriend'),
                                child: const Text("Ser amigo"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- SUPERPOSICIONES (OVERLAYS) ---
            if (gameProvider.gameScreen == GameScreen.selectingHealTarget)
              const HealSelectionWidget(),
            if (gameProvider.gameScreen == GameScreen.selectingSwitchTarget)
              const SwitchSelectionWidget(),
            if (gameProvider.gameScreen == GameScreen.answeringQuestion)
              const QuestionWidget(),
          ],
        );
      },
    );
  }
}
