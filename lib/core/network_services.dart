import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieService {
  final String apiKey = '35882e11';

  Future<List<dynamic>> searchMovies(String query) async {
    final url = Uri.parse('https://omdbapi.com/?s=$query&apikey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final movies = data['Search'] ?? [];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cachedQuery', query);
      await prefs.setString('cachedResult', json.encode(movies));

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> getMovieDetail(String imdbID) async {
    final url = Uri.parse('https://omdbapi.com/?i=$imdbID&apikey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }
}
