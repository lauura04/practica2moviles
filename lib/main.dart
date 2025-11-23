// lib/main.dart
import 'package:flutter/material.dart';
import 'package:practica2moviles/menu_principal.dart';
import 'package:provider/provider.dart'; // Importa provider
import 'providers/game_provider.dart';   // Importa tu GameProvider

void main() {
  // Aquí envolvemos toda la app con el ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Combate',
      theme: ThemeData.dark(), // Un tema oscuro queda bien para juegos
      home: MenuPrincipal(),
    );
  }
}
