// lib/screens/pantalla_jugar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

// Importamos los widgets que acabamos de crear
import 'screens/seleccion_widget.dart';
import 'screens/combate_widget.dart';
import 'screens/fin_juego_widget.dart';
import 'screens/game_won_widget.dart';
import 'screens/switch_pokemon_widget.dart';

class PantallaJugar extends StatelessWidget {
  const PantallaJugar({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Nos conectamos a GameProvider para escuchar sus cambios
    final gameProvider = Provider.of<GameProvider>(context);

    // 2. Creamos un widget vacío que llenaremos según el estado
    Widget currentScreen;

    // 3. Usamos un switch para decidir qué widget mostrar
    switch (gameProvider.gameScreen) {
      case GameScreen.pokemonSelection:
        currentScreen = const SelectionWidget();
        break;
      case GameScreen.combat:
      case GameScreen.selectingHealTarget:
      case GameScreen.selectingSwitchTarget:
      case GameScreen.answeringQuestion: // Se añade el nuevo estado aquí para mostrar CombatWidget
        currentScreen = const CombatWidget();
        break;
      case GameScreen.mustSwitchPokemon:
        currentScreen = const SwitchPokemonWidget();
        break;
      case GameScreen.gameOver:
        currentScreen = const GameOverWidget();
        break;
      case GameScreen.gameWon:
        currentScreen = const GameWonWidget();
        break;
    }

    // 4. Devolvemos la pantalla dentro de un Scaffold y con una animación
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini RPG de Combate"),
        backgroundColor: Colors.black54,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Una bonita transición de fundido (fade)
          return FadeTransition(opacity: animation, child: child);
        },
        // Aquí se coloca el widget que decidimos mostrar
        child: currentScreen,
      ),
    );
  }
}
