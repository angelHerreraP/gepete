import 'dart:convert'; // Añadido para manejar JSON

import 'package:flutter/material.dart';
import 'package:gepete/Menus/CustomAppBar.dart';
import 'package:gepete/Menus/Drawer.dart';
import 'package:http/http.dart' as http; // Añadido para solicitudes HTTP

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida inicial
    _messages.add(ChatMessage(
      text:
          'Hola! Estoy listo para ayudarte con el contenido de tu PDF. ¿En qué puedo asistirte?',
      isUser: false,
    ));
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _sendMessage() async {
    final String message = _controller.text.trim();
    if (message.isNotEmpty) {
      // Añadir mensaje del usuario
      setState(() {
        _messages.add(ChatMessage(text: message, isUser: true));
        _controller.clear();
      });

      try {
        // Realizar la solicitud HTTP
        final response = await http.post(
          Uri.parse('http://108.163.157.73:8000/query/'),
          body: {
            'question': message,
            'target_language': 'es',
            'model_name': 'llama2',
          },
        );

        if (response.statusCode == 200) {
          // Parsear la respuesta JSON
          final Map<String, dynamic> data = json.decode(response.body);

          // Añadir respuesta de la IA
          setState(() {
            _messages.add(ChatMessage(
              text: data['answer'] ?? 'No se pudo obtener una respuesta.',
              isUser: false,
            ));
          });
        } else {
          // Manejar errores de la solicitud
          setState(() {
            _messages.add(ChatMessage(
              text: 'Ups... Hubo un problema al comunicarte con el servidor.',
              isUser: false,
            ));
          });
        }
      } catch (e) {
        // Manejar errores de conexión
        setState(() {
          _messages.add(ChatMessage(
            text: 'Error de conexión. Intenta de nuevo más tarde.',
            isUser: false,
          ));
        });
      }

      // Desplazar al final del chat
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  color: message.isUser ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe algo...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) =>
                        _sendMessage(), // Añadir soporte para Enter
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
