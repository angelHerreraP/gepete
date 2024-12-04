import 'package:flutter/material.dart';
import 'package:gepete/Menus/CustomAppBar.dart';
import 'package:gepete/Menus/Drawer.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('¡Bienvenido a ChatGTP!'),
      ),
    );
  }
}
