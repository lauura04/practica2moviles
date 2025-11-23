// lib/providers/game_provider.dart

import 'package:flutter/material.dart';
import '../models/pokemon.dart';
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
}

class GameProvider with ChangeNotifier {
  // --- ESTADO DEL JUEGO ---
  GameScreen _gameScreen = GameScreen.pokemonSelection;
  Pokemon? _selectedPokemon;
  Pokemon? _currentEnemy;
  String _combatLog = "";
  int _currentEnemyIndex = 0;
  bool _isTurnProcessing = false;

  // --- GESTIÓN DE POKÉMON DEL JUGADOR ---
  List<Pokemon> _ownedPokemon = [];
  List<Pokemon> get playerTeam => _ownedPokemon;

  // --- DATOS DEL JUEGO (Listas inmutables) ---
  final List<Pokemon> _starterPokemonOptions = [
    Pokemon(name: "Charizard", maxHealth: 100, attackPower: 22, level: 5, imageAsset: "assets/charizard.png", isAlly: true),
    Pokemon(name: "Blastoise", maxHealth: 120, attackPower: 18, level: 5, imageAsset: "assets/blastoise.png", isAlly: true),
    Pokemon(name: "Venusaur", maxHealth: 110, attackPower: 20, level: 5, imageAsset: "assets/venusaur.png", isAlly: true),
  ];

  final List<Pokemon> _possibleEnemies = [
    Pokemon(name: "Gastly", maxHealth: 50, attackPower: 15, level: 3, imageAsset: "assets/gastly.png"),
    Pokemon(name: "Abra", maxHealth: 45, attackPower: 20, level: 3, imageAsset: "assets/abra.png"),
    Pokemon(name: "Haunter", maxHealth: 70, attackPower: 25, level: 4, imageAsset: "assets/haunter.png"),
    Pokemon(name: "Kadabra", maxHealth: 65, attackPower: 30, level: 4, imageAsset: "assets/kadabra.png"),
    Pokemon(name: "Gengar", maxHealth: 90, attackPower: 35, level: 5, imageAsset: "assets/gengar.png"),
    Pokemon(name: "Alakazam", maxHealth: 80, attackPower: 40, level: 5, imageAsset: "assets/alakazam.png"),
    Pokemon(name: "Gyarados", maxHealth: 130, attackPower: 30, level: 6, imageAsset: "assets/gyarados.png"),
    Pokemon(name: "Snorlax", maxHealth: 160, attackPower: 25, level: 6, imageAsset: "assets/snorlax.png"),
    Pokemon(name: "Mewtwo", maxHealth: 150, attackPower: 50, level: 8, imageAsset: "assets/mewtwo.png"),
    Pokemon(name: "Dragonite", maxHealth: 140, attackPower: 45, level: 8, imageAsset: "assets/dragonite.png"),
  ];

  // --- GETTERS (para que la UI lea el estado) ---
  GameScreen get gameScreen => _gameScreen;
  Pokemon? get selectedPokemon => _selectedPokemon;
  Pokemon? get currentEnemy => _currentEnemy;
  String get combatLog => _combatLog;
  List<Pokemon> get starterPokemonOptions => _starterPokemonOptions;
  bool get isTurnProcessing => _isTurnProcessing;
  Pokemon? get nextEnemy {
    final nextIndex = _currentEnemyIndex + 1;
    // Check if the next index is valid (within the bounds of the enemy list)
    if (nextIndex < _possibleEnemies.length) {
      return _possibleEnemies[nextIndex];
    }
    // If there is no next enemy (i.e., we are fighting the last one), return null.
    return null;
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
      _combatLog = "A wild ${_currentEnemy!.name} appeared!";
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
        _combatLog = "${_currentEnemy!.name} joined your team!";
      } else {
        _combatLog = "${_currentEnemy!.name} was sent to the PC Box because your team is full.";
      }
    }
  }

  void performForcedSwitch(Pokemon newPokemon) {
    if (newPokemon.currentHealth > 0 && newPokemon.isAlly) {
      _selectedPokemon = newPokemon;
      _gameScreen = GameScreen.combat;
      _combatLog = "Go, ${_selectedPokemon!.name}!";
      _isTurnProcessing = false;
      notifyListeners();
    }
  }

  void performVoluntarySwitch(Pokemon newPokemon) {
    _selectedPokemon = newPokemon;
    _combatLog = "You switched to ${_selectedPokemon!.name}!";
    _gameScreen = GameScreen.combat;
    notifyListeners();
    _triggerEnemyTurn(); // Cambiar consume el turno
  }

  void cancelSwitchSelection() {
    _gameScreen = GameScreen.combat;
    _isTurnProcessing = false;
    notifyListeners();
  }

  void healPokemon(Pokemon target) {
    final healAmount = Random().nextInt(26) + 25; // 25-50
    target.heal(healAmount);
    _combatLog = "${target.name} was healed for $healAmount HP!";
    _gameScreen = GameScreen.combat;
    notifyListeners();
    _triggerEnemyTurn(); // Curar consume el turno
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
        _combatLog += "\n${_currentEnemy!.name} strikes back...";

        if (_selectedPokemon!.currentHealth <= 0) {
          _combatLog += "\n${_selectedPokemon!.name} fainted!";
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

    _isTurnProcessing = true;
    notifyListeners();

    switch (action) {
      case 'attack':
        _currentEnemy!.takeDamage(_selectedPokemon!.attackPower);
        _combatLog = "${_selectedPokemon!.name} attacks and deals ${_selectedPokemon!.attackPower} damage.";
        break;

      case 'heal':
        _gameScreen = GameScreen.selectingHealTarget;
        _combatLog = "Who would you like to heal?";
        notifyListeners();
        return;

      case 'switch':
        _gameScreen = GameScreen.selectingSwitchTarget;
        _combatLog = "Switch to which Pokémon?";
        notifyListeners();
        return;

      case 'befriend':
        if (playerTeam.length >= 6) {
          _combatLog = "Your team is full! You cannot befriend more Pokémon.";
          _isTurnProcessing = false;
          notifyListeners();
          return;
        }
        if (Random().nextDouble() > 0.5) {
          _currentEnemy!.isAlly = true;
          _combatLog = "You convinced ${_currentEnemy!.name} to join your team!";
        } else {
          _combatLog = "You tried to befriend ${_currentEnemy!.name}, but it failed!";
        }
        break;
    }
    notifyListeners();

    bool combatHasEnded = false;
    if (_currentEnemy!.currentHealth <= 0) {
      combatHasEnded = true;
      _combatLog += "\n${_currentEnemy!.name} has been defeated!";
      for (var pokemon in playerTeam) {
        pokemon.levelUp();
      }
      _combatLog += "\nYour team leveled up!";
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
