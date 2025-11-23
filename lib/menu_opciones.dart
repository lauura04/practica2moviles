import 'package:flutter/material.dart';
import 'ajustes_sonido.dart';
import 'ajustes_visual.dart';

class MenuOpciones extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Fondo con imagen
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

          // Contenido principal
          Center(
            child: Column(
              children: [
                SizedBox(height: 120),
                Container(
                  width: 350,
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/ajustes.png'),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                SizedBox(height: 100),

                // Botón AJUSTES DE SONIDO
                _BotonOpcion(
                  texto: 'Ajustes de sonido',
                  imagen: 'assets/chatot.png',
                  color: Colors.red,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AjustesSonido()),
                    );
                  },
                ),
                SizedBox(height: 100),

                // Botón AJUSTES VISUALES
                _BotonOpcion(
                  texto: 'Ajustes Visuales',
                  imagen: 'assets/smeargle.png', // ← Tu imagen visual
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AjustesVisuales()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Widget para los botones de opciones CON IMAGEN
class _BotonOpcion extends StatelessWidget {
  final String texto;
  final String imagen; // ← Cambiado de IconData a String
  final Color color;
  final VoidCallback onPressed;

  const _BotonOpcion({
    required this.texto,
    required this.imagen,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen en lugar de icono
            Container(
              width: 64,
              height: 128,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagen),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15),
            Text(
              texto,
              style: TextStyle(
                fontSize: 16, // ← Un poco más pequeño para caber mejor
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}