// lib/providers/game_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pokemon.dart';
import '../models/pregunta.dart';
import 'dart:math';

// Enum con todos los posibles estados de la pantalla del juego
enum GameScreen {
  pokemonSelection,
  combat,
  selectingHealTarget,
  selectingSwitchTarget, // Estado para cuando el jugador elige cambiar de Pokémon
  mustSwitchPokemon,     // Estado para cuando el jugador está forzado a cambiar
  gameOver,
  gameWon,
  answeringQuestion, // Estado para cuando el jugador responde una pregunta
}

class GameProvider with ChangeNotifier {
  // --- ESTADO DEL JUEGO ---
  GameScreen _gameScreen = GameScreen.pokemonSelection;
  Pokemon? _selectedPokemon;
  Pokemon? _currentEnemy;
  String _combatLog = "";
  int _currentEnemyIndex = 0;
  bool _isTurnProcessing = false;

  // --- PREGUNTAS ---
  List<Pregunta> _preguntas = [];
  Pregunta? _currentQuestion;
  String? _pendingAction; // Acción que se ejecutará si se responde correctamente
  Pokemon? _healTarget;
  Pokemon? _switchTarget;

  // --- GESTIÓN DE POKÉMON DEL JUGADOR ---
  List<Pokemon> _ownedPokemon = [];
  List<Pokemon> get playerTeam => _ownedPokemon;

  // --- DATOS DEL JUEGO (Listas inmutables) ---
  final List<Pokemon> _starterPokemonOptions = [
    Pokemon(name: "Charizard", maxHealth: 100, attackPower: 22, level: 5, imageAsset: "sprites_pokes/charizardFront.png", backImageAsset: "sprites_pokes/charizardBack.png", isAlly: true),
    Pokemon(name: "Blastoise", maxHealth: 120, attackPower: 18, level: 5, imageAsset: "sprites_pokes/blastoiseFront.png", backImageAsset: "sprites_pokes/blastoiseBack.png", isAlly: true),
    Pokemon(name: "Venusaur", maxHealth: 110, attackPower: 20, level: 5, imageAsset: "sprites_pokes/venusaurFront.png", backImageAsset: "sprites_pokes/venusaurBack.png", isAlly: true),
  ];

  final List<Pokemon> _possibleEnemies = [
    Pokemon(name: "Gastly", maxHealth: 50, attackPower: 15, level: 3, imageAsset: "sprites_pokes/gastlyFront.png", backImageAsset: "sprites_pokes/gastlyBack.png"),
    Pokemon(name: "Abra", maxHealth: 45, attackPower: 20, level: 3, imageAsset: "sprites_pokes/abraFront.png", backImageAsset: "sprites_pokes/abraBack.png"),
    Pokemon(name: "Haunter", maxHealth: 70, attackPower: 25, level: 4, imageAsset: "sprites_pokes/haunterFront.png", backImageAsset: "sprites_pokes/haunterBack.png"),
    Pokemon(name: "Kadabra", maxHealth: 65, attackPower: 30, level: 4, imageAsset: "sprites_pokes/kadabraFront.png", backImageAsset: "sprites_pokes/kadabraBack.png"),
    Pokemon(name: "Gengar", maxHealth: 90, attackPower: 35, level: 5, imageAsset: "sprites_pokes/gengarFront.png", backImageAsset: "sprites_pokes/gengarBack.png"),
    Pokemon(name: "Alakazam", maxHealth: 80, attackPower: 40, level: 5, imageAsset: "sprites_pokes/alakazamFront.png", backImageAsset: "sprites_pokes/alakazamBack.png"),
    Pokemon(name: "Gyarados", maxHealth: 130, attackPower: 30, level: 6, imageAsset: "sprites_pokes/gyaradosFront.png", backImageAsset: "sprites_pokes/gyaradosBack.png"),
    Pokemon(name: "Snorlax", maxHealth: 160, attackPower: 25, level: 6, imageAsset: "sprites_pokes/snorlaxFront.png", backImageAsset: "sprites_pokes/snorlaxBack.png"),
    Pokemon(name: "Mewtwo", maxHealth: 150, attackPower: 50, level: 8, imageAsset: "sprites_pokes/mewtwoFront.png", backImageAsset: "sprites_pokes/mewtwoBack.png"),
    Pokemon(name: "Dragonite", maxHealth: 140, attackPower: 45, level: 8, imageAsset: "sprites_pokes/dragoniteFront.png", backImageAsset: "sprites_pokes/dragoniteBack.png"),
  ];

  // --- GETTERS (para que la UI lea el estado) ---
  GameScreen get gameScreen => _gameScreen;
  Pokemon? get selectedPokemon => _selectedPokemon;
  Pokemon? get currentEnemy => _currentEnemy;
  String get combatLog => _combatLog;
  List<Pokemon> get starterPokemonOptions => _starterPokemonOptions;
  bool get isTurnProcessing => _isTurnProcessing;
  Pregunta? get currentQuestion => _currentQuestion;

  Pokemon? get nextEnemy {
    final nextIndex = _currentEnemyIndex + 1;
    // Check if the next index is valid (within the bounds of the enemy list)
    if (nextIndex < _possibleEnemies.length) {
      return _possibleEnemies[nextIndex];
    }
    // If there is no next enemy (i.e., we are fighting the last one), return null.
    return null;
  }

  GameProvider() {
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/preguntas.json');
      final List<dynamic> data = json.decode(response);
      _preguntas = data.map((json) => Pregunta.fromJson(json)).toList();
    } catch (e) {
      print("Error cargando las preguntas: $e");
      _combatLog = "Error cargando las preguntas. La partida continuara sin estas.";
    }
  }

  void _showRandomQuestion(String action) {
    if (_preguntas.isEmpty) {
      // Si no hay preguntas, ejecutar acción directamente
      _executeAction(action);
      return;
    }
    _currentQuestion = _preguntas[Random().nextInt(_preguntas.length)];
    _pendingAction = action;
    _gameScreen = GameScreen.answeringQuestion;
    notifyListeners();
  }

  void checkAnswer(String selectedOption) {
    if (_currentQuestion == null) return;

    bool isCorrect = selectedOption == _currentQuestion!.respuestaCorrecta;
    
    if (isCorrect) {
      _combatLog = "¡Correcto!.";
      if (_pendingAction != null) {
        _executeAction(_pendingAction!);
      }
    } else {
      _combatLog = "Respuesta incorrecta, pierdes turno.";
      _gameScreen = GameScreen.combat;
      _triggerEnemyTurn();
    }
    _pendingAction = null;
    _currentQuestion = null;
    _healTarget = null;
    _switchTarget = null;
    notifyListeners();
  }

  // --- LÓGICA DE COMBATE Y ESTADO ---

  void startNextCombat() {
    bool canContinue = playerTeam.any((p) => p.currentHealth > 0);
    if (!canContinue) {
      _gameScreen = GameScreen.gameOver;
      notifyListeners();
      return;
    }
    if (_selectedPokemon == null || _selectedPokemon!.currentHealth <= 0) {
      _selectedPokemon = playerTeam.firstWhere((p) => p.currentHealth > 0);
    }
    if (_currentEnemyIndex >= _possibleEnemies.length) {
      _gameScreen = GameScreen.gameWon;
    } else {
      _currentEnemy = _possibleEnemies[_currentEnemyIndex];
      _gameScreen = GameScreen.combat;
      _combatLog = "Un ${_currentEnemy!.name} salvaje ha aparecido!";
    }
    notifyListeners();
  }

  void selectStarterPokemon(Pokemon starter) {
    starter.resetToInitialState();
    _ownedPokemon = [starter];
    _selectedPokemon = starter;
    _currentEnemyIndex = 0;
    startNextCombat();
  }

  void endCombat(bool playerWon) {
    if (playerWon) {
      _currentEnemyIndex++;
      startNextCombat();
    } else {
      _gameScreen = GameScreen.gameOver;
      notifyListeners();
    }
    _isTurnProcessing = false;
  }

  void addBefriendedPokemon() {
    if (_currentEnemy != null && _currentEnemy!.isAlly) {
      if (playerTeam.length < 6) {
        _ownedPokemon.add(_currentEnemy!);
        _combatLog = "¡${_currentEnemy!.name} se ha unido a tu equipo!";
      } else {
        _combatLog = "${_currentEnemy!.name} fue enviado a la PC porque tu equipo está lleno.";
      }
    }
  }

  void performForcedSwitch(Pokemon newPokemon) {
    if (newPokemon.currentHealth > 0 && newPokemon.isAlly) {
      _selectedPokemon = newPokemon;
      _gameScreen = GameScreen.combat;
      _combatLog = "¡Vamos ${_selectedPokemon!.name}!";
      _isTurnProcessing = false;
      notifyListeners();
    }
  }

  void performVoluntarySwitch(Pokemon newPokemon) {
    // Interceptar el cambio para hacer pregunta
    _switchTarget = newPokemon;
    _showRandomQuestion('complete_switch');
  }

  void cancelSwitchSelection() {
    _gameScreen = GameScreen.combat;
    _isTurnProcessing = false;
    notifyListeners();
  }

  void healPokemon(Pokemon target) {
    // Interceptar curación para hacer pregunta
    _healTarget = target;
    _showRandomQuestion('complete_heal');
  }

  void _completeHeal() {
    if (_healTarget == null) return;
    final healAmount = Random().nextInt(26) + 25; // 25-50
    _healTarget!.heal(healAmount);
    _combatLog = "¡${_healTarget!.name} se curó $healAmount HP!";
    _gameScreen = GameScreen.combat;
    _healTarget = null;
    notifyListeners();
    _triggerEnemyTurn(); // Curar consume el turno
  }

  void _completeSwitch() {
    if (_switchTarget == null) return;
    _selectedPokemon = _switchTarget;
    _combatLog = "¡Cambiaste a ${_selectedPokemon!.name}!";
    _gameScreen = GameScreen.combat;
    _switchTarget = null;
    notifyListeners();
    _triggerEnemyTurn(); // Cambiar consume el turno
  }

  void cancelHealSelection() {
    _gameScreen = GameScreen.combat;
    _isTurnProcessing = false;
    notifyListeners();
  }

  void _triggerEnemyTurn() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (_selectedPokemon != null && _selectedPokemon!.currentHealth > 0) {
        _selectedPokemon!.takeDamage(_currentEnemy!.attackPower);
        _combatLog += "\n${_currentEnemy!.name} ataca de vuelta...";

        if (_selectedPokemon!.currentHealth <= 0) {
          _combatLog += "¡\n${_selectedPokemon!.name} se debilita!";
          bool canSwitch = playerTeam.any((p) => p.currentHealth > 0);
          if (canSwitch) {
            _gameScreen = GameScreen.mustSwitchPokemon;
          } else {
            Future.delayed(const Duration(seconds: 2), () => endCombat(false));
          }
        } else {
          _isTurnProcessing = false;
        }
        notifyListeners();
      }
    });
  }

  void performCombatAction(String action) {
    if (_isTurnProcessing) return;
    if (_selectedPokemon == null || _currentEnemy == null) return;
    if (_selectedPokemon!.currentHealth <= 0) return;

    // Acciones que requieren pregunta antes de ejecutarse
    if (action == 'attack' || action == 'befriend') {
       _showRandomQuestion(action);
       return;
    }

    if (action == 'heal') {
        _gameScreen = GameScreen.selectingHealTarget;
        _combatLog = "¿A quién quieres curar?";
        notifyListeners();
        return;
    }
    
    if (action == 'switch') {
        _gameScreen = GameScreen.selectingSwitchTarget;
        _combatLog = "¿A qué Pokémon cambias?";
        notifyListeners();
        return;
    }
  }

  void _executeAction(String action) {
    _isTurnProcessing = true;
    _gameScreen = GameScreen.combat; // Volver a combate para mostrar log/animación
    notifyListeners();

    if (action == 'complete_heal') {
        _completeHeal();
        return;
    }

    if (action == 'complete_switch') {
        _completeSwitch();
        return;
    }

    switch (action) {
      case 'attack':
        _currentEnemy!.takeDamage(_selectedPokemon!.attackPower);
        _combatLog = "${_selectedPokemon!.name} ataca y hace ${_selectedPokemon!.attackPower} de daño.";
        break;

      case 'befriend':
        if (playerTeam.length >= 6) {
          _combatLog = "Tu equipo está completo, no puedes reclutar más Pokemon";
          _isTurnProcessing = false;
          notifyListeners();
          return;
        }
        if (Random().nextDouble() > 0.5) {
          _currentEnemy!.isAlly = true;
          _combatLog = "¡Convenciste a ${_currentEnemy!.name} para unirse a tu equipo!";
        } else {
          _combatLog = "¡Intentaste ser amigo de ${_currentEnemy!.name}, pero has fallado!";
        }
        break;
    }
    notifyListeners();

    bool combatHasEnded = false;
    if (_currentEnemy!.currentHealth <= 0) {
      combatHasEnded = true;
      _combatLog += "¡\n${_currentEnemy!.name} ha sido derrotado!";
      for (var pokemon in playerTeam) {
        pokemon.levelUp();
      }
      _combatLog += "\n¡Tu equipo ha subido de nivel!";
      Future.delayed(const Duration(seconds: 2), () => endCombat(true));
    } else if (_currentEnemy!.isAlly) {
      combatHasEnded = true;
      addBefriendedPokemon();
      Future.delayed(const Duration(seconds: 2), () => endCombat(true));
    }

    notifyListeners();

    if (!combatHasEnded) {
      _triggerEnemyTurn();
    }
  }

  // --- REINICIO DEL JUEGO ---
  void restartGame() {
    _gameScreen = GameScreen.pokemonSelection;
    _ownedPokemon = [];
    _selectedPokemon = null;
    _currentEnemy = null;
    _combatLog = "";
    _currentEnemyIndex = 0;
    _isTurnProcessing = false;

    for (var pokemon in _starterPokemonOptions) {
      pokemon.resetToInitialState();
    }
    for (var pokemon in _possibleEnemies) {
      pokemon.resetToInitialState();
    }
    notifyListeners();
  }

  void switchActivePokemon(Pokemon pokemon) {}
}
