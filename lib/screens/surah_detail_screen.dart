import 'package:flutter/material.dart';

import '../models/quran_model.dart';

class SurahDetailScreen extends StatelessWidget {
  final SurahDetail detail;

  const SurahDetailScreen({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final s = detail.summary;
    return Scaffold(
      appBar: AppBar(title: Text(s.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Nomor: ${s.number} • ${s.revelationType} • ${s.englishNameTranslation}', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: detail.arabicAyahs.isEmpty
                ? const Center(child: Text('Teks surah belum tersedia.'))
                : Scrollbar(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: detail.arabicAyahs.length,
                      itemBuilder: (context, index) {
                        final arab = detail.arabicAyahs[index];
                        final translit = index < detail.transliterationAyahs.length 
                            ? detail.transliterationAyahs[index] 
                            : QuranAyah(number: index + 1, numberInSurah: index + 1, juz: 0, text: '');
                        final translation = index < detail.translationAyahs.length 
                            ? detail.translationAyahs[index] 
                            : QuranAyah(number: index + 1, numberInSurah: index + 1, juz: 0, text: '');

                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(alignment: Alignment.centerRight, child: Text('${arab.numberInSurah}', style: TextStyle(color: Colors.grey[600]))),
                                const SizedBox(height: 6),
                                Text(arab.text, textAlign: TextAlign.right, style: const TextStyle(fontSize: 20, height: 1.6)),
                                const SizedBox(height: 8),
                                Text(translit.text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                                const SizedBox(height: 6),
                                Text(translation.text, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}