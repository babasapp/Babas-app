import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(
                        title: const Text("Babas App"),
                                centerTitle: true,
                                        backgroundColor: Colors.green,
                                              ),
                                                    body: const Center(
                                                            child: Text(
                                                                      "Assalamu'alaikum\nSelamat Datang di Babas App",
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