import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_services.dart';

// Service provider
final movieServiceProvider = Provider<MovieService>((ref) => MovieService());

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Movie list provider
final movieListProvider = FutureProvider<List>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final service = ref.watch(movieServiceProvider);
  return service.searchMovies(query);
});

// Cache movie list
final cachedMoviesProvider = FutureProvider<List>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('cachedResult');
  if (jsonString != null) {
    return json.decode(jsonString);
  }
  return [];
});

// Movie detail provider
final movieDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, imdbID) async {
  final service = ref.watch(movieServiceProvider);
  return service.getMovieDetail(imdbID);
});
