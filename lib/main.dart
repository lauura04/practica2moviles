// lib/main.dart
import 'package:flutter/material.dart';
import 'package:practica2moviles/menu_principal.dart';
import 'package:provider/provider.dart';
import 'package:practica2moviles/providers/settings_provider.dart';
import 'providers/game_provider.dart';
import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración global del contexto de audio para permitir mezcla de sonidos
  await AudioPlayer.global.setAudioContext(AudioContext(
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

  runApp(
    // 👇 Usa MultiProvider para registrar todos tus providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, GameProvider>(
          create: (context) => GameProvider(
            Provider.of<SettingsProvider>(context, listen: false),
          ),
          update: (context, settings, gameProvider) => gameProvider!,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha solo a SettingsProvider para los cambios de tema
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Juego de Combate',
          debugShowCheckedModeBanner: false,
          // El tema ahora es controlado por el provider de ajustes
          theme: settings.currentTheme,
          home: MenuPrincipal(),
        );
      },
    );
  }
}
