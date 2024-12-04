import 'package:flutter/material.dart';

class ChatHistoryWidget extends StatelessWidget {
  final List<Map<String, String>> messages;

  const ChatHistoryWidget({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          leading: Icon(
            message['type'] == 'user' ? Icons.person : Icons.smart_toy,
            color: message['type'] == 'user' ? Colors.blue : Colors.green,
          ),
          title: Text(message['text'] ?? ''),
        );
      },
    );
  }
}
