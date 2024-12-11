import 'package:flutter/material.dart';
import 'package:gepete/Screens/LoadFile.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PDFUploadPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'Assets/Images/Logo.png', // Carga siempre el mismo logo
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      ),
      backgroundColor: Colors.white, // Fija un fondo blanco
    );
  }
}
