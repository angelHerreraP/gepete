import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              // Se mantiene el fondo con la imagen, pero limitamos el tamaño
              image: DecorationImage(
                image: AssetImage('Assets/Images/Logo.png'),
                fit:
                    BoxFit.contain, // Ajusta la imagen al tamaño del contenedor
              ),
            ),
            child:
                null, // No es necesario agregar un hijo, ya que la imagen está como fondo
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ajustes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir (o no 😜)'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('¡Ja! No puedes salir de ChatGTP 😏')),
              );
            },
          ),
        ],
      ),
    );
  }
}
