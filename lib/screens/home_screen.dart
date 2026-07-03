import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(
                        title: const Text("🕌 Babas App"),
                                centerTitle: true,
                                      ),

                                            body: ListView(
                                                    padding: const EdgeInsets.all(16),
                                                            children: [

                                                                      menuTile("📖 Al-Qur'an"),
                                                                                menuTile("🕌 Jadwal Sholat"),
                                                                                          menuTile("🤲 Doa & Dzikir"),
                                                                                                    menuTile("🎧 Murottal"),
                                                                                                              menuTile("📅 Kalender Islami"),
                                                                                                                        menuTile("🌤 Cuaca"),
                                                                                                                                  menuTile("📚 Kitab Maulid"),
                                                                                                                                            menuTile("⭐ Premium"),
                                                                                                                                                      menuTile("⚙️ Pengaturan"),
                                                                                                                                                              ],
                                                                                                                                                                    ),
                                                                                                                                                                        );
                                                                                                                                                                          }

                                                                                                                                                                            Widget menuTile(String title) {
                                                                                                                                                                                return Card(
                                                                                                                                                                                      child: ListTile(
                                                                                                                                                                                              title: Text(title),
                                                                                                                                                                                                      trailing: const Icon(Icons.arrow_forward_ios),
                                                                                                                                                                                                              onTap: () {
                                                                                                                                                                                                                        // nanti isi navigasi
                                                                                                                                                                                                                                },
                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                          );
                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                            }