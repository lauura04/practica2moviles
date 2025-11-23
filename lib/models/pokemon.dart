// lib/models/pokemon.dart

class Pokemon {
  String name;
  int maxHealth;
  int currentHealth;
  int attackPower;
  int level;
  String imageAsset;
  bool isAlly;

  // --- NEW: Base stats to allow resetting ---
  final int _baseMaxHealth;
  final int _baseAttackPower;
  final int _baseLevel;

  Pokemon({
    required this.name,
    required this.maxHealth,
    required this.attackPower,
    required this.level,
    required this.imageAsset,
    this.isAlly = false,
  })  : currentHealth = maxHealth,
  // When a Pokemon is created, store its initial stats
        _baseMaxHealth = maxHealth,
        _baseAttackPower = attackPower,
        _baseLevel = level;

  void takeDamage(int amount) {
    currentHealth -= amount;
    if (currentHealth < 0) {
      currentHealth = 0;
    }
  }

  void heal(int amount) {
    currentHealth += amount;
    if (currentHealth > maxHealth) {
      currentHealth = maxHealth;
    }
  }

  void resetHealth() {
    currentHealth = maxHealth;
  }

  void levelUp() {
    level++;
    maxHealth += 10;
    attackPower += 5;
    heal(10);
  }

  // --- NEW: Full Reset Method ---
  // Resets all stats, including level, to their original values.
  void resetToInitialState() {
    level = _baseLevel;
    maxHealth = _baseMaxHealth;
    attackPower = _baseAttackPower;
    currentHealth = _baseMaxHealth; // Restore to full health
  }
}
