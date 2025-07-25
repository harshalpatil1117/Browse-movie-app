import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieService {
  final String apiKey = '35882e11';

  Future<List<dynamic>> searchMovies(String query) async {
    if (!await checkInternetConnectivity()) {
      throw 'You’re offline! Please check your internet connection.';
    }

    final url = Uri.parse('https://omdbapi.com/?s=$query&apikey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Response'] == 'True') {
        final movies = data['Search'] ?? [];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cachedQuery', query);
        await prefs.setString('cachedResult', json.encode(movies));

        return movies;
      } else {
        throw data['Error'] ?? 'No movies found';
      }
    } else {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<Map<String, dynamic>> getMovieDetail(String imdbID) async {
    if (!await checkInternetConnectivity()) {
      throw 'You’re offline! Please check your internet connection.';
    }

    final url = Uri.parse('https://omdbapi.com/?i=$imdbID&apikey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Response'] == 'True') {
        return data;
      } else {
        throw data['Error'] ?? 'Movie detail not available';
      }
    } else {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) return false;

      final test = await http
          .get(Uri.parse("https://www.google.com"))
          .timeout(const Duration(seconds: 3));

      return test.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
