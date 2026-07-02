import 'dart:convert';

import 'package:http/http.dart' as http;

class QuranService {
  QuranService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  Future<List<dynamic>> fetchSurahs() async {
    final response = await _client.get(Uri.parse('$_baseUrl/surah'));
    return _parseResponse<List<dynamic>>(
      response,
      (data) {
        if (data is List) {
          return data;
        }
        throw const FormatException('Unexpected response format for surahs');
      },
    );
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
