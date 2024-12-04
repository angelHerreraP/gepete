import 'package:flutter/material.dart';

class RandomResponseButton extends StatelessWidget {
  final List<String> responses = [
    "Procesando... 🤔",
    "¿Eso es todo lo que tienes? 😂",
    "Estoy 99% seguro de que no sé la respuesta.",
    "¿Otra pr4egunta difícil? 😅",
    "¡Claro! La respuesta es 42. 😎",
  ];

  RandomResponseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final randomResponse = responses[(responses.length *
                (0.5 + 0.5 * (DateTime.now().millisecondsSinceEpoch % 1)))
            .toInt()];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Respuesta de ChatGTP'),
            content: Text(randomResponse),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.question_answer),
      label: const Text('Obtener Respuesta Aleatoria'),
    );
  }
}
