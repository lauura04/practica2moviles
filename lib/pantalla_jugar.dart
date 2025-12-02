import 'dart:async';
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
  StreamSubscription? _playerCompleteSubscription;
  bool _combatMusicPlayed = false;
  bool _selectionMusicPlayed = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // Configuración del contexto de audio para permitir la mezcla de sonidos
    // Esto evita que los efectos de sonido detengan la música de fondo
    AudioPlayer.global.setAudioContext(AudioContext(
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.none, 
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
        options: [AVAudioSessionOptions.mixWithOthers],
      ),
    ));
  }

  Future<void> _playSelectionMusic() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.musicActivada) {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(settings.volumenGeneral);
      await _audioPlayer.play(AssetSource('Music/33-select.your.pokemon.mp3'));
    }
  }

  Future<void> _playCombatMusic() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.musicActivada) {
      await _playerCompleteSubscription?.cancel();
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(settings.volumenGeneral);

      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource('Music/pokemon-battle.mp3'));

      _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
        _audioPlayer.setReleaseMode(ReleaseMode.loop);
        _audioPlayer.play(AssetSource('Music/MusicaDeFondo.mp3'));
      });
    }
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // --- Music Logic ---
    final currentGameScreen = gameProvider.gameScreen;
    final bool isCombatActive =
        currentGameScreen == GameScreen.combat ||
        currentGameScreen == GameScreen.selectingHealTarget ||
        currentGameScreen == GameScreen.selectingSwitchTarget ||
        currentGameScreen == GameScreen.answeringQuestion ||
        currentGameScreen == GameScreen.mustSwitchPokemon;

    if (currentGameScreen == GameScreen.pokemonSelection && !_selectionMusicPlayed) {
      _playSelectionMusic();
      _selectionMusicPlayed = true;
    } else if (isCombatActive && !_combatMusicPlayed) {
      _playCombatMusic();
      _combatMusicPlayed = true;
      _selectionMusicPlayed = false; // Reset for next time
    } else if (!isCombatActive && ! (currentGameScreen == GameScreen.pokemonSelection) && (_combatMusicPlayed || _selectionMusicPlayed)) {
      _audioPlayer.stop();
      _combatMusicPlayed = false;
      _selectionMusicPlayed = false;
    }
    // --- End of Music Logic ---

    Widget currentScreen;
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _audioPlayer.stop();
        Provider.of<GameProvider>(context, listen: false).restartGame();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mini RPG de Combate"),
          backgroundColor: Colors.black54,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: currentScreen,
        ),
      ),
    );
  }
}
