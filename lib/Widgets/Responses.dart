import 'package:flutter/material.dart';

class ResponseWidget extends StatelessWidget {
  final String responseText; // El texto de la respuesta
  final bool isError; // Indica si la respuesta es un "error" humorístico

  const ResponseWidget({
    super.key,
    required this.responseText,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? Colors.red.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? Colors.red : Colors.blue,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.chat_bubble_outline,
            color: isError ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              responseText,
              style: TextStyle(
                fontSize: 16,
                color: isError ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
