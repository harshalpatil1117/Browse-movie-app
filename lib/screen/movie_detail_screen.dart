import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../core/providers.dart';

class MovieDetailScreen extends ConsumerWidget {
  final String imdbID;

  const MovieDetailScreen({super.key, required this.imdbID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final movieAsync = ref.watch(movieDetailProvider(imdbID));

    return Scaffold(
      backgroundColor: Colors.black,
      body: movieAsync.when(
        loading:
            () => Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.grey[900],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            height: 15,
                            width: double.infinity,
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        error:
            (err, stack) => Center(
              child: Text(
                'Error: $err',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        data:
            (movie) => SafeArea(
              child: Stack(
                children: [
                  Hero(
                    tag: movie['imdbID'],
                    child: Image.network(
                      movie['Poster'],
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
                    maxChildSize: 0.85,
                    builder:
                        (_, controller) => Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            controller: controller,
                            children: [
                              Text(
                                movie['Title'] ?? 'N/A',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.clock,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie['Runtime'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                children: [
                                  if (movie['Genre'] != null)
                                    ...movie['Genre']
                                        .split(', ')
                                        .map(
                                          (g) => Chip(
                                            label: Text(g),
                                            backgroundColor: Colors.black
                                                .withOpacity(0.5),
                                            labelStyle: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            padding: EdgeInsets.all(2),
                                          ),
                                        ),
                                ],
                              ),
                              Divider(),
                              const SizedBox(height: 16),
                              Text(
                                movie['Plot'] ?? 'No plot available.',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Director: ${movie['Director'] ?? '-'}',
                                style: const TextStyle(color: Colors.white54),
                              ),
                              Text(
                                'Writer: ${movie['Writer'] ?? '-'}',
                                style: const TextStyle(color: Colors.white54),
                              ),
                              Text(
                                'Actors: ${movie['Actors'] ?? '-'}',
                                style: const TextStyle(color: Colors.white54),
                              ),
                              Text(
                                'Country: ${movie['Country'] ?? '-'}',
                                style: const TextStyle(color: Colors.white54),
                              ),
                              Text(
                                'Released: ${movie['Released'] ?? '-'}',
                                style: const TextStyle(color: Colors.white54),
                              ),
                              Text(
                                'IMDB: ${movie['imdbRating'] ?? '-'}',
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_outlined),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
