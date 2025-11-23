import 'package:flutter/material.dart';
import 'pantalla_jugar.dart';
import 'menu_opciones.dart';

class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.deepOrange,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              'Juego',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
          SizedBox(height: 80),

          // Botón para iniciar el juego
          _BotonMenu(
            texto: 'Jugar',
            color: Colors.green,
            icono: Icons.play_arrow,
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
              color: Colors.blue,
              icono: Icons.settings,
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
              color: Colors.red,
              icono: Icons.exit_to_app,
              onPressed: () {
                _mostrarDialogoSalir(context);
              },
            ),
            ],
          ),
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
  final Color color;
  final IconData icono;
  final VoidCallback onPressed;

  const _BotonMenu({
    required this.texto,
    required this.color,
    required this.icono,
    required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}