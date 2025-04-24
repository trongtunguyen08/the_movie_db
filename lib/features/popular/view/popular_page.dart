import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_movie_db/core/widgets/movie_card.dart';
import 'package:the_movie_db/features/popular/view_model/popular_view_model.dart';

class PopularPage extends ConsumerStatefulWidget {
  const PopularPage({super.key});

  @override
  ConsumerState<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends ConsumerState<PopularPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(popularViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularMovieState = ref.watch(popularViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Popular")),
      body: RefreshIndicator(
        child: popularMovieState.when(
          data: (movies) {
            if (movies.isEmpty) {
              return const Center(child: Text("Data Not Found!"));
            }
            return GridView.builder(
              controller: _scrollController,
              itemCount: movies.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 8 / 14,
              ),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie: movie);
              },
            );
          },
          error: (error, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(error.toString()),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(popularViewModelProvider);
                  },
                  child: const Text("Retry!"),
                ),
              ],
            );
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
        onRefresh: () {
          return ref.read(popularViewModelProvider.notifier).onRefresh();
        },
      ),
    );
  }
}
