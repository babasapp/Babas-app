import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

    @override
      State<SplashScreen> createState() => _SplashScreenState();
      }

      class _SplashScreenState extends State<SplashScreen> {
        @override
          void initState() {
              super.initState();

                  Timer(const Duration(seconds: 3), () {
                        Navigator.pushReplacement(
                                context,
                                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                                              );
                                                  });
                                                    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B7A3B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/babas_logo.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 100,
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Babas App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Cahaya Al-Qur'an Dalam Genggaman",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}