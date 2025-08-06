import 'package:flutter/material.dart';
import 'package:quiz_app/pages/splash_page.dart'; // Vamos criar esta página a seguir

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quem Sabe, Sabe!',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(), // A porta de entrada do nosso app
    );
  }
}