import 'package:flutter/material.dart';
import 'package:gepete/Menus/CustomAppBar.dart';
import 'package:gepete/Menus/Drawer.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = []; // Lista para almacenar los mensajes

  // Función que simula obtener una respuesta
  void _getResponse(String query) {
    setState(() {
      _messages.add("Tú: $query"); // Agrega el mensaje del usuario
      _messages.add("ChatGTP: " + query); // Agrega la respuesta de "ChatGTP"
    });
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: _messages[index].startsWith('Tú:')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: _messages[index].startsWith('Tú:')
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _messages[index],
                        style: TextStyle(
                          color: _messages[index].startsWith('Tú:')
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
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
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _getResponse(_controller.text);
                      _controller.clear(); // Limpia el campo de texto
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
