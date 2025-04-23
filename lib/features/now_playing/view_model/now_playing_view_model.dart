import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_movie_db/core/models/movie_model.dart';
import 'package:the_movie_db/features/now_playing/repositories/now_playing_repository.dart';

part 'now_playing_view_model.g.dart';

@riverpod
class NowPlayingViewModel extends _$NowPlayingViewModel {
  late NowPlayingRepository _nowPlayingRepository;

  @override
  AsyncValue<List<MovieModel>>? build() {
    _nowPlayingRepository = ref.watch(nowPlayingRepositoryProvider);
    return null;
  }

  Future<void> getNowPlayingMovieList() async {
    state = const AsyncValue.loading();
    final res = await _nowPlayingRepository.fetchNowPlaying();
    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
