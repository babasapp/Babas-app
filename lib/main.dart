import 'package:flutter/material.dart';

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
                              theme: ThemeData.dark(),
                                    home: const HomePage(),
                                        );
                                          }
                                          }

                                          class HomePage extends StatelessWidget {
                                            const HomePage({super.key});

                                              @override
                                                Widget build(BuildContext context) {
                                                    return Scaffold(
                                                          appBar: AppBar(
                                                                  title: const Text("Babas App"),
                                                                        ),
                                                                              body: const Center(
                                                                                      child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                                      Text(
                                                                                                                                    "📖",
                                                                                                                                                  style: TextStyle(fontSize: 72),
                                                                                                                                                              ),
                                                                                                                                                                          SizedBox(height: 20),
                                                                                                                                                                                      Text(
                                                                                                                                                                                                    "Cahaya Al-Qur'an dalam Genggaman",
                                                                                                                                                                                                                  textAlign: TextAlign.center,
                                                                                                                                                                                                                                style: TextStyle(
                                                                                                                                                                                                                                                fontSize: 22,
                                                                                                                                                                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                                                                                    ],
                                                                                                                                                                                                                                                                                                            ),
                                                                                                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                                                                                                      );
                                                                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                                                                                        }