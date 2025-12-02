import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practica2moviles/providers/settings_provider.dart';

class AjustesVisuales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondoAjustes.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Contenido
          Center(
            child: Column(
              children: [
                SizedBox(height: 120),
                Container(
                  width: 350,
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/visual.png'),
                    ),
                  ),
                ),
                SizedBox(height: 100),
                _ItemConfiguracionVisual(
                  icono: Icons.dark_mode,
                  titulo: 'Modo Oscuro',
                  valor: settings.modoOscuro,
                  onChanged: (valor) {
                    settings.setModoOscuro(valor);
                  },
                ),
                SizedBox(height: 210),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemConfiguracionVisual extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool valor;
  final Function(bool) onChanged;

  const _ItemConfiguracionVisual({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icono, color: Colors.red),
                SizedBox(width: 10),
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
      ),
    );
  }
}