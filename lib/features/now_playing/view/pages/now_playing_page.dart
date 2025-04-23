import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_movie_db/features/now_playing/view_model/now_playing_view_model.dart';

class NowPlayingPage extends ConsumerStatefulWidget {
  const NowPlayingPage({super.key});

  @override
  ConsumerState<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends ConsumerState<NowPlayingPage> {
  @override
  void initState() {
    ref.read(nowPlayingViewModelProvider.notifier).getNowPlayingMovieList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(nowPlayingViewModelProvider, (_, next) {
      next?.when(
        data: (data) {},
        error: (error, stackTrace) {},
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: Center(child: const Text("Now Playing")),
    );
  }
}
