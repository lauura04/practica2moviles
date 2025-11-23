import 'package:flutter/material.dart';

class PantallaJugar extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Juego'),
        backgroundColor: Colors.green,
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ),
      body: Container(
        color: Colors.green[50],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(
                Icons.sports_esports,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                'Preparate para jugar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 20),
              Text (
                'Contenido del juego',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700]
                ),
              ),
            ],
          ),
        ),
      ),
      );
  }
}