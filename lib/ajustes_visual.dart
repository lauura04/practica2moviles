import 'package:flutter/material.dart';

class AjustesVisuales extends StatefulWidget {
  @override
  _AjustesVisualesState createState() => _AjustesVisualesState();
}

class _AjustesVisualesState extends State<AjustesVisuales> {
  bool _modoOscuro = false;
  bool _efectosAnimaciones = true;
  double _tamanioTexto = 16.0;

  @override
  Widget build(BuildContext context) {
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
                  valor: _modoOscuro,
                  onChanged: (valor) {
                    setState(() {
                      _modoOscuro = valor;
                    });
                  },
                ),
                SizedBox(height: 20),
                _ItemConfiguracionVisual(
                  icono: Icons.animation,
                  titulo: 'Efectos y Animaciones',
                  valor: _efectosAnimaciones,
                  onChanged: (valor) {
                    setState(() {
                      _efectosAnimaciones = valor;
                    });
                  },
                ),
                SizedBox(height: 210),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Cambios guardados correctamente!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Image.asset(
                        'assets/ajustesIcon.png',
                        width: 48,
                        height: 48,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Guardar Cambios',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                      ),
                    ],
                  ),

                ),
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