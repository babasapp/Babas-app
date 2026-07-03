import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranService {

  Future<dynamic> fetchSurahDetail(int surah) async {
      final url = Uri.parse(
            "https://api.quran.gading.dev/surah/$surah"
                );

                    final res = await http.get(url);

                        if (res.statusCode != 200) {
                              throw Exception("Gagal load surah");
                                  }

                                      final data = jsonDecode(res.body);
                                          return data['data'];
                                            }

                                              Future<String> getTafsir(int surah, int ayah) async {
                                                  final url = Uri.parse(
                                                        "https://api.quran.gading.dev/surah/$surah/$ayah/tafsir"
                                                            );

                                                                final res = await http.get(url);

                                                                    if (res.statusCode != 200) {
                                                                          return "-";
                                                                              }

                                                                                  final data = jsonDecode(res.body);

                                                                                      return data['data']['tafsir']['id']['long'] ?? "-";
                                                                                        }
                                                                                        }