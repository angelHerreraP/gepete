import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gepete/Menus/CustomAppBar.dart';
import 'package:gepete/Menus/Drawer.dart';
import 'package:gepete/Screens/App.dart'; // Importa la clase de la página de chat que creamos anteriormente
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PDFUploadPage extends StatefulWidget {
  const PDFUploadPage({super.key});

  @override
  _PDFUploadPageState createState() => _PDFUploadPageState();
}

class _PDFUploadPageState extends State<PDFUploadPage> {
  File? _selectedFile;
  String _errorMessage = '';

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Verificar que es un archivo PDF
        if (path.extension(file.path).toLowerCase() == '.pdf') {
          setState(() {
            _selectedFile = file;
            _errorMessage = '';
          });
        } else {
          _showErrorDialog('Por favor, selecciona solo archivos PDF');
        }
      }
    } catch (e) {
      _showErrorDialog('Error al seleccionar archivo: ${e.toString()}');
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      setState(() {
        _errorMessage = 'No se seleccionó un archivo.';
      });
      return;
    }

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://108.163.157.73:8000/pdf/upload'));

      request.files
          .add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Leer la respuesta
        var responseBody = await response.stream.bytesToString();
        print('Respuesta del servidor: $responseBody');

        // Navegar a la página de chat
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const App()));
      } else {
        // Manejar errores de respuesta
        var errorBody = await response.stream.bytesToString();
        setState(() {
          _errorMessage = 'Error al subir el archivo: $errorBody';
        });
        print('Error en la subida: $errorBody');
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error al subir el archivo: ${error.toString()}';
      });
      print('Error al subir el archivo: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade100,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Carga tu documento PDF',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue.shade300,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue.shade50,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.blue.shade500,
                                size: 60,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Arrastra tu archivo PDF aquí o haz clic para seleccionar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              if (_selectedFile != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  path.basename(_selectedFile!.path),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _selectedFile != null ? _uploadFile : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Subir archivo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
