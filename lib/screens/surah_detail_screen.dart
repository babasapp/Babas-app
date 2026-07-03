import 'package:flutter/material.dart';

import '../models/quran_model.dart';
import '../services/quran_service.dart';

class SurahDetailScreen extends StatefulWidget {
  final QuranSurahSummary surah;

  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late final QuranService _service;
  late final Future<SurahDetail> _detailFuture;
  double _ayahFontSize = 18;
  bool _landscapeMode = false;

  @override
  void initState() {
    super.initState();
    _service = QuranService();
    _detailFuture = _service.fetchSurahDetail(widget.surah.number);
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
        title: Text(widget.surah.name),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<SurahDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat detail surah.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _detailFuture = _service.fetchSurahDetail(widget.surah.number);
                        });
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = snapshot.data;
          if (detail == null) {
            return const Center(child: Text('Tidak ada data surah.'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(detail)),
              SliverToBoxAdapter(child: _buildControlPanel(detail)),
              SliverToBoxAdapter(child: _buildFeatureSection()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ayah = detail.arabicAyahs[index];
                    final translation = index < detail.translationAyahs.length
                        ? detail.translationAyahs[index].text
                        : 'Terjemahan belum tersedia.';
                    final transliteration = index < detail.transliterationAyahs.length
                        ? detail.transliterationAyahs[index].text
                        : 'Transliterasi belum tersedia.';
                    return _buildAyahCard(
                      context,
                      ayah,
                      translation,
                      transliteration,
                    );
                  },
                  childCount: detail.arabicAyahs.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(SurahDetail detail) {
    return Container(
      width: double.infinity,
      color: Colors.green.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.summary.name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            detail.summary.englishName,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildInfoChip('Surah ${detail.summary.number}'),
              _buildInfoChip('${detail.summary.numberOfAyahs} ayat'),
              _buildInfoChip(detail.summary.revelationType),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ayat Arab, Latin, dan Terjemahan Bahasa Indonesia ditampilkan untuk membangun pengalaman membaca Al-Qur’an yang lengkap.',
            style: const TextStyle(color: Colors.black87),
          ),
          if (detail.warningMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              detail.warningMessage!,
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlPanel(SurahDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_size, color: Colors.green),
              const SizedBox(width: 8),
              const Expanded(child: Text('Pengaturan ukuran huruf')),
            ],
          ),
          Slider(
            value: _ayahFontSize,
            min: 14,
            max: 28,
            divisions: 7,
            label: '${_ayahFontSize.round()} pt',
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                _ayahFontSize = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Mode Mushaf (Landscape) Aktifkan struktur)'),
            value: _landscapeMode,
            activeThumbColor: Colors.green,
            activeTrackColor: Colors.green.shade200,
            onChanged: (value) {
              setState(() {
                _landscapeMode = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection() {
    const features = [
      _QuranFeatureData('Tafsir', Icons.menu_book),
      _QuranFeatureData('Murottal', Icons.music_note),
      _QuranFeatureData('Bookmark', Icons.bookmark),
      _QuranFeatureData('Last Read', Icons.history),
      _QuranFeatureData('Mode Landscape', Icons.screen_rotation),
      _QuranFeatureData('Cache/Offline', Icons.cloud_off),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rencana Fitur',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: features
                .map(
                  (feature) => Chip(
                    label: Text(feature.title),
                    avatar: Icon(feature.icon, size: 18, color: Colors.green.shade700),
                    backgroundColor: Colors.green.shade50,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          const Text(
            'Struktur ini memudahkan pengembangan fitur berikutnya: tafsir, murottal, bookmark, last read, mode landscape, dan cache/offline.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(
    BuildContext context,
    QuranAyah ayah,
    String translation,
    String transliteration,
  ) {
    final cardPadding = _landscapeMode ? const EdgeInsets.all(24) : const EdgeInsets.all(16);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ayat ${ayah.numberInSurah}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  ayah.text,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: _ayahFontSize + 2,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                transliteration,
                style: TextStyle(fontSize: _ayahFontSize - 2, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                translation,
                style: TextStyle(fontSize: _ayahFontSize - 2, color: Colors.black54, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _QuranFeatureData {
  final String title;
  final IconData icon;

  const _QuranFeatureData(this.title, this.icon);
}
