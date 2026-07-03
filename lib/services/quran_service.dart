import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/quran_model.dart';

class QuranService {
  QuranService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _arabicEdition = 'ar.quran-simple';
  static const String _transliterationEdition = 'en.transliteration';
  static const String _translationEdition = 'id.indonesian';

  Future<List<QuranSurahSummary>> fetchSurahs() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/surah'));
      return _parseResponse<List<QuranSurahSummary>>(
        response,
        (data) {
          if (data is List) {
            return data
                .whereType<Map<String, dynamic>>()
                .map(QuranSurahSummary.fromJson)
                .toList();
          }
          throw const FormatException('Unexpected response format for surahs');
        },
      );
    } catch (_) {
      return _loadLocalSurahs();
    }
  }

  Future<List<QuranSurahSummary>> _loadLocalSurahs() async {
    final jsonString = await rootBundle.loadString('assets/data/quran.json');
    final decoded = jsonDecode(jsonString);
    if (decoded is Map<String, dynamic> && decoded['code'] == 200) {
      final data = decoded['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(QuranSurahSummary.fromJson)
            .toList();
      }
    }
    throw const FormatException('Local Quran data format invalid');
  }

  Future<SurahDetail> fetchSurahDetail(int surahNumber) async {
    final arabicFuture = _fetchSurahEdition(surahNumber, _arabicEdition);
    final transliterationFuture = _fetchSurahEdition(surahNumber, _transliterationEdition);
    final translationFuture = _fetchSurahEdition(surahNumber, _translationEdition);

    final results = await Future.wait([arabicFuture, transliterationFuture, translationFuture]);
    final arabicSurah = results[0];
    final transliterationSurah = results[1];
    final translationSurah = results[2];

    String? warningMessage;
    if (arabicSurah.ayahs.length != translationSurah.ayahs.length || arabicSurah.ayahs.length != transliterationSurah.ayahs.length) {
      warningMessage = 'Beberapa ayat mungkin tidak terpasang sempurna antara Arab, Latin, dan Terjemahan.';
    }

    return SurahDetail(
      summary: arabicSurah.summary,
      arabicAyahs: arabicSurah.ayahs,
      transliterationAyahs: transliterationSurah.ayahs,
      translationAyahs: translationSurah.ayahs,
      warningMessage: warningMessage,
    );
  }

  Future<QuranSurah> _fetchSurahEdition(int surahNumber, String edition) async {
    final response = await _client.get(Uri.parse('$_baseUrl/surah/$surahNumber/$edition'));
    final decoded = _parseResponse<Map<String, dynamic>>(
      response,
      (data) {
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        throw const FormatException('Unexpected response format for surah edition');
      },
    );
    return QuranSurah.fromJson(decoded);
  }

  Future<Map<String, dynamic>> fetchSurah(int surahNumber) async {
    final response = await _client.get(Uri.parse('$_baseUrl/surah/$surahNumber'));
    return _parseResponse<Map<String, dynamic>>(
      response,
      (data) {
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        throw const FormatException('Unexpected response format for surah');
      },
    );
  }

  Future<Map<String, dynamic>> fetchAyah(int surahNumber, int ayahNumber) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/ayah/$surahNumber/$ayahNumber'),
    );
    return _parseResponse<Map<String, dynamic>>(
      response,
      (data) {
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        throw const FormatException('Unexpected response format for ayah');
      },
    );
  }

  Future<Map<String, dynamic>> fetchAyahRange(
    int surahNumber, {
    int? fromAyah,
    int? toAyah,
  }) async {
    final queryParameters = <String, String>{};
    if (fromAyah != null) {
      queryParameters['from'] = fromAyah.toString();
    }
    if (toAyah != null) {
      queryParameters['to'] = toAyah.toString();
    }

    final response = await _client.get(
      Uri.parse('$_baseUrl/surah/$surahNumber').replace(
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      ),
    );

    return _parseResponse<Map<String, dynamic>>(
      response,
      (data) {
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        throw const FormatException('Unexpected response format for ayah range');
      },
    );
  }

  Future<void> prepareOfflineCache() async {
    // Placeholder for offline cache preparation.
  }

  Future<void> clearOfflineCache() async {
    // Placeholder for clearing Quran cache data.
  }

  T _parseResponse<T>(http.Response response, T Function(dynamic data) parser) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load Quran data: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded['code'] == 200) {
      return parser(decoded['data']);
    }

    throw const FormatException('Invalid Quran API response');
  }

  void dispose() {
    _client.close();
  }
}
