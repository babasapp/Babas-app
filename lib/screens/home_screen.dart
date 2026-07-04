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
                                        Center(
                                                child: Column(
                                                        children: [
                                                                Image.asset(
                                                                        'assets/images/babas_logo.png',
                                                                        width: 120,
                                                                        height: 120,
                                                                        fit: BoxFit.contain,
                                                                ),
                                                                const SizedBox(height: 12),
                                                                Text(
                                                                        "Assalamu'alaikum",
                                                                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                                                                ),
                                                                const SizedBox(height: 4),
                                                                const Text(
                                                                        "Babas App",
                                                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                                ),
                                                                const SizedBox(height: 4),
                                                                Text(
                                                                        "Cahaya Al-Qur'an Dalam Genggaman",
                                                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                                ),
                                                        ],
                                                ),
                                        ),
                                        const SizedBox(height: 20),

                                        menuTile("📖 Al-Qur'an"),
                                        menuTile("🕌 Jadwal Sholat"),
                                        menuTile("🤲 Doa & Dzikir"),
                                        menuTile("🎧 Murottal"),
                                        menuTile("📅 Kalender Islami"),
                                        menuTile("🌤 Cuaca"),
                                        menuTile("📚 Kitab Maulid"),
                                        menuTile("⭐ Premium"),
                                        menuTile("⚙️ Pengaturan"),

                                        const SizedBox(height: 24),
                                        Column(
                                                children: const [
                                                        Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
                                                        SizedBox(height: 4),
                                                        Text("© Babas App", style: TextStyle(color: Colors.grey)),
                                                ],
                                        ),
                                ],
                        ),
                );
        }
}

Widget menuTile(String title) {
        return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(title),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                                // nanti isi navigasi
                        },
                ),
        );
}