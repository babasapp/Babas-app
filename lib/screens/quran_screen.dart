import 'package:flutter/material.dart';

import '../models/quran_model.dart';
import '../screens/surah_detail_screen.dart';
import '../services/quran_service.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late final QuranService _service;
  late final Future<List<QuranSurahSummary>> _surahsFuture;
  String _searchQuery = '';

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
      body: FutureBuilder<List<QuranSurahSummary>>(
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

          final surahs = snapshot.data ?? const <QuranSurahSummary>[];
          final filteredSurahs = _searchQuery.isEmpty
              ? surahs
              : surahs.where((surah) {
                  final query = _searchQuery.toLowerCase();
                  return surah.name.toLowerCase().contains(query) ||
                      surah.englishName.toLowerCase().contains(query) ||
                      surah.englishNameTranslation.toLowerCase().contains(query) ||
                      surah.number.toString().contains(query);
                }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Cari nama surat, nomor, atau terjemahan...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredSurahs.isEmpty
                    ? const Center(child: Text('Tidak ada surat yang cocok.'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredSurahs.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final surah = filteredSurahs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: Text(
                                surah.number.toString(),
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                            title: Text(surah.name),
                            subtitle: Text(
                              '${surah.englishName} • ${surah.englishNameTranslation}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SurahDetailScreen(surah: surah),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
