import 'package:flutter/material.dart';

import '../models/quran_model.dart';
import '../services/quran_service.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final QuranService _service = QuranService();
  late final Future<List<QuranSurahSummary>> _surahsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _surahsFuture = _service.fetchSurahs();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  void _openSurahDetail(int surahNumber) async {
    final detail = await _service.fetchSurahDetail(surahNumber);
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => SurahDetailScreen(detail: detail)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Al-Qur'an")),
      body: FutureBuilder<List<QuranSurahSummary>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat daftar surah. ${snapshot.error}'));
          }

          final surahs = snapshot.data ?? <QuranSurahSummary>[];
          final filtered = _searchQuery.isEmpty
              ? surahs
              : surahs.where((s) {
                  final q = _searchQuery.toLowerCase();
                  return s.name.toLowerCase().contains(q) ||
                      s.englishName.toLowerCase().contains(q) ||
                      s.englishNameTranslation.toLowerCase().contains(q) ||
                      s.number.toString().contains(q);
                }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari surat atau nomor...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final s = filtered[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(radius: 20, child: Text(s.number.toString(), style: const TextStyle(fontSize: 14))),
                        title: Text(s.englishName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name),
                            const SizedBox(height: 4),
                            Text('${s.englishNameTranslation} • ${s.revelationType}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _openSurahDetail(s.number),
                      ),
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
