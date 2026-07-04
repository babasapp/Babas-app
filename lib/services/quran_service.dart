import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/quran_model.dart';

class QuranService {
  Future<List<QuranSurahSummary>> fetchSurahs() async {
    final raw = await rootBundle.loadString('assets/data/quran_complete.json');
    final Map<String, dynamic> json = jsonDecode(raw);
    final List data = json['data'] as List? ?? [];
    return data.map((e) => QuranSurahSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SurahDetail> fetchSurahDetail(int number) async {
    // Try to load per-surah file; if not present return empty lists with summary only
    final summaryList = await fetchSurahs();
    final summary = summaryList.firstWhere((s) => s.number == number, orElse: () => QuranSurahSummary(number: number, name: 'Surah $number', englishName: 'Surah $number', englishNameTranslation: '', revelationType: '', numberOfAyahs: 0));

    final path = 'assets/data/surah_$number.json';
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> json = jsonDecode(raw);
      final List ayahs = json['ayahs'] as List? ?? [];

      final arabic = ayahs
          .asMap()
          .entries
          .map((entry) => QuranAyah(
                number: entry.value['number'] ?? entry.key + 1,
                numberInSurah: entry.value['number'] ?? entry.key + 1,
                juz: entry.value['juz'] ?? 0,
                text: entry.value['arab'] ?? '',
              ))
          .toList();

      final translit = ayahs
          .asMap()
          .entries
          .map((entry) => QuranAyah(
                number: entry.value['number'] ?? entry.key + 1,
                numberInSurah: entry.value['number'] ?? entry.key + 1,
                juz: entry.value['juz'] ?? 0,
                text: entry.value['latin'] ?? '',
              ))
          .toList();

      final translation = ayahs
          .asMap()
          .entries
          .map((entry) => QuranAyah(
                number: entry.value['number'] ?? entry.key + 1,
                numberInSurah: entry.value['number'] ?? entry.key + 1,
                juz: entry.value['juz'] ?? 0,
                text: entry.value['translation'] ?? '',
              ))
          .toList();

      return SurahDetail(
        summary: summary,
        arabicAyahs: arabic,
        transliterationAyahs: translit,
        translationAyahs: translation,
      );
    } catch (e) {
      return SurahDetail(summary: summary, arabicAyahs: [], transliterationAyahs: [], translationAyahs: []);
    }
  }

  Future<void> dispose() async {}
}
