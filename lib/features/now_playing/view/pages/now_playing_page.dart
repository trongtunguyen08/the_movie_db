import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_movie_db/core/contants/server_contants.dart';
import 'package:the_movie_db/features/now_playing/view_model/now_playing_view_model.dart';

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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: movie.posterPath,
                        child: Image.network(
                          "${ServerContants.apiImageURL}${movie.posterPath}",
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(movie.releaseDate),
                        ],
                      ),
                    ),
                  ],
                );
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
