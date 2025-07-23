import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../core/providers.dart';
import 'movie_detail_screen.dart';

class MovieGridScreen extends ConsumerStatefulWidget {
  const MovieGridScreen({super.key});

  @override
  ConsumerState<MovieGridScreen> createState() => _MovieGridScreenState();
}

class _MovieGridScreenState extends ConsumerState<MovieGridScreen> {
  final TextEditingController _searchController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _loadCachedSearch();
  }

  Future<void> _loadCachedSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedQuery = prefs.getString('cachedQuery');
    if (cachedQuery != null) {
      _searchController.text = cachedQuery;
      ref.read(searchQueryProvider.notifier).state = cachedQuery;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(searchQueryProvider);
    final moviesAsync = searchQuery.trim().isEmpty
        ? ref.watch(cachedMoviesProvider)
        : ref.watch(movieListProvider);


    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Browse',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Movies',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _searchController,
                onChanged:
                    (value) =>
                        ref.read(searchQueryProvider.notifier).state = value,
                onFieldSubmitted: (_) => ref.refresh(movieListProvider),
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),

                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Colors.white
                      )
                  )
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  onRefresh: () async {
                    ref.invalidate(movieListProvider);
                    ref.invalidate(cachedMoviesProvider);
                  },
                  child: moviesAsync.when(
                    data:
                        (movies)
                        {
                          if (movies.isEmpty && _searchController.text.trim().isEmpty) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: Center(
                                  child: Image.asset(
                                    'assets/no_movies_found.png',
                                    width: 220,
                                  ),
                                ),
                              ),
                            );
                          }
                          return GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.48,
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return GestureDetector(
                              onTap:
                                  () =>
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 1000,
                                      ),
                                      pageBuilder:
                                          (_, __, ___) =>
                                          MovieDetailScreen(
                                            imdbID: movie['imdbID'],
                                          ),
                                    ),
                                  ),
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: movie['imdbID'],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: FadeInImage.assetNetwork(
                                        height: 150,
                                        width: double.infinity,
                                        placeholder: 'assets/placeholder.png',
                                        // Add a placeholder asset
                                        image:
                                        movie['Poster'] != 'N/A'
                                            ? movie['Poster']
                                            : 'assets/placeholder.png',
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                            Image.asset(
                                              'assets/placeholder.png',
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    movie['Title'] ?? 'N/A',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    movie['Year'],
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );},
                    loading:
                        () => GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.48,
                              ),
                          itemCount: 6, // shimmer placeholders
                          itemBuilder:
                              (context, index) => Shimmer.fromColors(
                                baseColor: Colors.grey[800]!,
                                highlightColor: Colors.grey[700]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                        ),
                    error:
                        (err, stack) => Center(
                          child: Text(
                            'Error: $err',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
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
