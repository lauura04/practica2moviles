import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final question = gameProvider.currentQuestion;

    if (question == null) return const SizedBox();

    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent, width: 2),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Pregunta (${question.dificultad})",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  question.pregunta,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (question.fuenteDato != null && 
                   (question.tipo == 'imagen_4_opciones' || question.fuenteDato!.endsWith('.png') || question.fuenteDato!.endsWith('.jpg')))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Image.asset(
                      'assets/${question.fuenteDato}',
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 50, 
                          child: Center(child: Text("Imagen no encontrada"))
                        );
                      },
                    ),
                  ),
                if (question.tipo == 'musica')
                   const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "[Reproducción de música no disponible]",
                      style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                    ),
                  ),
                const SizedBox(height: 8),
                ...question.opciones.map((opcion) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          gameProvider.checkAnswer(opcion);
                        },
                        child: Text(opcion, style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
