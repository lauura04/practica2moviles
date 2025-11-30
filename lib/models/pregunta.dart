class Pregunta {
  final String tipo;
  final String dificultad;
  final String pregunta;
  final List<String> opciones;
  final String respuestaCorrecta;
  final String? fuenteDato;

  Pregunta({
    required this.tipo,
    required this.dificultad,
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
    this.fuenteDato,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      tipo: json['tipo'],
      dificultad: json['dificultad'],
      pregunta: json['pregunta'],
      opciones: List<String>.from(json['opciones']),
      respuestaCorrecta: json['respuestaCorrecta'],
      fuenteDato: json['fuenteDato'],
    );
  }
}
