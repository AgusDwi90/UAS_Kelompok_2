// 5ZEsFGRb9Rs16V5un_v-h

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/music.dart';

class ApiService {
  static const String baseUrl = 'https://osdb-api.confidence.sh/rest';
  static const String apiKey = '5ZEsFGRb9Rs16V5un_v-h';

  Future<List<Music>> fetchMusic() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$apiKey/album?page=1&limit=20'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> data = responseData['data'] ?? [];
        return data.map((json) => Music.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load music');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}