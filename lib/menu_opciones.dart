import 'package:flutter/material.dart';

class MenuOpciones extends StatefulWidget {
  @override
  _MenuOpcionesState createState() => _MenuOpcionesState();
}

class _MenuOpcionesState extends State<MenuOpciones>{
  bool _sonidoActivado = true;
  bool _musicaActivada = true;
  double _volumen = 0.5;
  //otras configuraciones

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('MenuOpciones'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.blue[50],
          padding: EdgeInsets.all(20),
          child: Column(
            children:[
              _ItemConfiguration(
                icono: Icons.volume_up,
                titulo: 'Sonido',
                valor: _sonidoActivado,
                onChanged: (valor) {
                  setState(() {
                    _sonidoActivado = valor;
                  });
                },
              ),
              _ItemConfiguration(
                icono: Icons.music_note,
                titulo: 'Musica',
                valor: _musicaActivada,
                onChanged: (valor) {
                  setState(() {
                    _musicaActivada = valor;
                  });
                },
              ),

              //control volumen
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.volume_down, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            'Volumen',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Slider(
                        value: _volumen,
                        onChanged: (valor){
                          setState(() {
                            _volumen = valor;
                          });
                        },
                        min: 0,
                        max: 1,
                        divisions: 10,
                        label: '${(_volumen*100).round()}%'
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),

              //guardar configuracion
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    _mostrarMensajeGuardado(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'GUARDAR CONFIGURACION',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void _mostrarMensajeGuardado(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Configuracion guardada'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _ItemConfiguration extends StatelessWidget{
  final IconData icono;
  final String titulo;
  final bool valor;
  final Function(bool) onChanged;

  const _ItemConfiguration({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children:[
                Icon(icono, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Switch(
              value: valor,
              onChanged: onChanged,
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}