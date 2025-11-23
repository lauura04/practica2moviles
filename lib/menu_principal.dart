import 'package:flutter/material.dart';
import 'pantalla_jugar.dart';
import 'menu_opciones.dart';

class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fnd.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),


            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 220),
                  Container(
                    width: 350,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/titulo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 100),

                  // Botón para iniciar el juego
                  _BotonMenu(
                    texto: 'Jugar',
                    colorTexto: Colors.black,
                    icono: Icons.play_arrow,
                    imagenFondo: 'assets/fondoBotones.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PantallaJugar()),
                      );
                    },
                  ),
                  SizedBox(height: 30),

                  //Boton opciones
                  _BotonMenu (
                    texto: 'Opciones',
                    colorTexto: Colors.black,
                    icono: Icons.settings,
                    imagenFondo: 'assets/fondoBotones.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuOpciones()),
                      );
                    },
                  ),
                  SizedBox(height: 30),

                  //Boton Salir
                  _BotonMenu (
                    texto: 'Salir',
                    colorTexto: Colors.black,
                    icono: Icons.exit_to_app,
                    imagenFondo: 'assets/fondoBotones.jpg',
                    onPressed: () {
                      _mostrarDialogoSalir(context);
                    },
                  ),
                ],
              ),
            ),

            //charmander
            Positioned(
              bottom: 40,
              right: 20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/charmander.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            //eevee
            Positioned(
              bottom: -10,
              right: 150,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/eevee.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            //pikachu
            Positioned(
              bottom: 720,
              right: 50,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pikachu.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            //victini
            Positioned(
              bottom: 400,
              right: 170,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/victini.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

          ],
        ),
      );
  }

  void _mostrarDialogoSalir(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Salir del juego'),
          content: Text('¿Estás seguro de que deseas salir del juego?'),
          actions: [
            TextButton(
            child: Text('Cancelar'),
            onPressed: (){
              Navigator.of(context).pop();
            },
            ),
            TextButton(
            child: Text('Salir'),
            onPressed: (){
              Navigator.of(context).pop();
        },
        ),
        ],
        );
      },
    );
  }
}

class _BotonMenu extends StatelessWidget {
  final String texto;
  final Color colorTexto;
  final IconData icono;
  final VoidCallback onPressed;
  final String imagenFondo;

  const _BotonMenu({
    required this.texto,
    required this.colorTexto,
    required this.icono,
    required this.onPressed,
    required this.imagenFondo,
  });


  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // ← IMPORTANTE: transparente
          foregroundColor: colorTexto,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero, // ← IMPORTANTE: eliminar padding interno
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage( // ← AQUÍ aplicas la imagen de fondo
              image: AssetImage(imagenFondo),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icono, size: 24),
                SizedBox(width: 10),
                Text(
                  texto,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [ // ← Añade sombra para mejor legibilidad
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}