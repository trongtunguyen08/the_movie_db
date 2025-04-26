import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb/core/widgets/movie_card.dart';
import 'package:tmdb/screens/now_playing/view_model/now_playing_view_model.dart';

class NowPlayingPage extends ConsumerStatefulWidget {
  const NowPlayingPage({super.key});

  @override
  ConsumerState<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends ConsumerState<NowPlayingPage> {
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
      ref.read(nowPlayingViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingState = ref.watch(nowPlayingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Now Playing")),
      body: RefreshIndicator(
        child: nowPlayingState.when(
          data: (movies) {
            if (movies.isEmpty) {
              return Center(child: const Text("No Data Found!"));
            }
            return GridView.builder(
              itemCount: movies.length,
              controller: _scrollController,
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
                    ref.invalidate(nowPlayingViewModelProvider);
                  },
                  child: const Text("Retry!"),
                ),
              ],
            );
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
        onRefresh: () {
          return ref.read(nowPlayingViewModelProvider.notifier).onRefresh();
        },
      ),
    );
  }
}
