import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BabasApp());
}

class BabasApp extends StatelessWidget {
  const BabasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Babas App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}