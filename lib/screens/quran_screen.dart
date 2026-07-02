import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(
                        title: const Text("Al-Qur'an"),
                                backgroundColor: Colors.green,
                                      ),
                                            body: const Center(
                                                    child: Text(
                                                              "📖 Halaman Al-Qur'an\n\nSegera Hadir",
                                                                        textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                              fontSize: 24,
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                            ),
                                                                                                                                  ),
                                                                                                                                      );
                                                                                                                                        }
                                                                                                                                        }