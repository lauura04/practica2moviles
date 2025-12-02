import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:practica2moviles/providers/game_provider.dart';
import 'package:practica2moviles/providers/settings_provider.dart';

// Importamos los widgets
import 'screens/seleccion_widget.dart';
import 'screens/combate_widget.dart';
import 'screens/fin_juego_widget.dart';
import 'screens/game_won_widget.dart';
import 'screens/switch_pokemon_widget.dart';

class PantallaJugar extends StatefulWidget {
  const PantallaJugar({super.key});

  @override
  State<PantallaJugar> createState() => _PantallaJugarState();
}

class _PantallaJugarState extends State<PantallaJugar> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // Ejecutamos la música después de que el widget se haya montado para poder acceder al context de forma segura si fuera necesario, 
    // aunque para read(listen: false) se puede hacer directo, pero es mejor práctica esperar o usar un bloque asíncrono.
    _initMusic();
  }

  Future<void> _initMusic() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    
    if (settings.musicActivada) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(settings.volumenGeneral);
      // AudioPlayer v6 usa AssetSource y asume la carpeta 'assets/' como raíz.
      await _audioPlayer.play(AssetSource('Music/MusicaDeFondo.mp3'));
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

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
      case GameScreen.answeringQuestion:
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
