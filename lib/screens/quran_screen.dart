import 'package:flutter/material.dart';

import '../services/quran_service.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late final QuranService _service;
  late final Future<List<dynamic>> _surahsFuture;

  @override
  void initState() {
    super.initState();
    _service = QuranService();
    _surahsFuture = _service.fetchSurahs();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Qur\'an'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat daftar surah.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final surahs = snapshot.data ?? const <dynamic>[];

          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              final surahMap = surah is Map<String, dynamic>
                  ? surah
                  : <String, dynamic>{};
              final name = surahMap['name'] ?? 'Surah ${index + 1}';
              final englishName = surahMap['englishName'] ?? '';

              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(name.toString()),
                subtitle: englishName.isEmpty ? null : Text(englishName.toString()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          );
        },
      ),
    );
  }
}