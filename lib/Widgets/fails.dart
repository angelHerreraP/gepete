import 'dart:math';

import 'package:flutter/material.dart';

class RandomResponseButton extends StatefulWidget {
  const RandomResponseButton({super.key});

  @override
  _RandomResponseButtonState createState() => _RandomResponseButtonState();
}

class _RandomResponseButtonState extends State<RandomResponseButton> {
  final List<String> responses = [
    "Procesando... 🤔",
    "¿Eso es todo lo que tienes? 😂",
    "Estoy 99% seguro de que no sé la respuesta.",
    "¿Otra pr4egunta difícil? 😅",
    "¡Claro! La respuesta es 42. 😎",
  ];

  final Random _random = Random();
  String? _lastResponse;

  String _getRandomResponse() {
    // Asegura que la respuesta sea diferente a la última
    String newResponse;
    do {
      newResponse = responses[_random.nextInt(responses.length)];
    } while (newResponse == _lastResponse && responses.length > 1);

    _lastResponse = newResponse;
    return newResponse;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final randomResponse = _getRandomResponse();
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
