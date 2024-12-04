import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Asegura que los widgets estén centrados
          children: const [
            Icon(Icons.message, color: Colors.white),
            SizedBox(width: 8),
            Text('GePeTe'),
          ],
        ),
      ),
    );
  }

  @override
  // Implementamos preferredSize
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight); // Establece la altura estándar del AppBar
}
