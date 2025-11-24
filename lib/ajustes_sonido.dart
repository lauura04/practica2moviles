import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practica2moviles/providers/settings_provider.dart';


class AjustesSonido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Barra superior transparente
        elevation: 0, // Sin sombra
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Fondo de pantalla que ocupa todo el espacio
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondoAjustes.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay oscuro para mejorar la legibilidad
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Contenido principal centrado
          Center(
            child: SingleChildScrollView( // Usamos SingleChildScrollView para evitar overflow si hay muchos items
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding general
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80), // Espacio superior para que no choque con la barra de atrás
                    // --- Título Gráfico ---
                    Container(
                      width: 350,
                      height: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/sonido.png'),
                          fit: BoxFit.contain, // Contain es mejor para no cortar el título
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // --- Tarjeta para los Switches ---
                    Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          _ItemConfiguracionSonido(
                            icono: Icons.volume_up,
                            titulo: 'Sonido',
                            valor: settings.sonidoActivado,
                            onChanged: (valor) {
                              settings.setSonidoActivado(valor);
                            },
                          ),
                          Divider(height: 1, indent: 16, endIndent: 16), // Separador visual
                          _ItemConfiguracionSonido(
                            icono: Icons.music_note,
                            titulo: 'Música de fondo',
                            valor: settings.musicActivada,
                            onChanged: (valor) {
                              settings.setMusicaActivada(valor);
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // --- Slider para Volumen General ---
                    _ItemConfiguracionSlider(
                      icono: Icons.graphic_eq,
                      titulo: 'Volumen General',
                      valor: settings.volumenGeneral,
                      onChanged: (nuevoValor) {
                        settings.setVolumenGeneral(nuevoValor);
                      },
                    ),

                    SizedBox(height: 20),

                    // --- Slider para Efectos de Sonido ---
                    _ItemConfiguracionSlider(
                      icono: Icons.surround_sound,
                      titulo: 'Efectos de Sonido',
                      valor: settings.volumenEfectos,
                      onChanged: (nuevoValor) {
                        settings.setVolumenEfectos(nuevoValor);
                      },
                    ),

                    SizedBox(height: 40), // Espacio antes del botón de guardar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget reutilizable para los items con Switch ---
class _ItemConfiguracionSonido extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool valor;
  final Function(bool) onChanged;

  const _ItemConfiguracionSonido({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icono, color: Colors.red, size: 28),
              SizedBox(width: 15),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Switch(
            value: valor,
            onChanged: onChanged,
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

// --- Widget reutilizable para los items con Slider ---
class _ItemConfiguracionSlider extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final double valor;
  final Function(double) onChanged;

  const _ItemConfiguracionSlider({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: Colors.red, size: 28),
                SizedBox(width: 15),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Slider(
              value: valor,
              onChanged: onChanged,
              min: 0.0,
              max: 1.0,
              activeColor: Colors.red,
              inactiveColor: Colors.red.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
