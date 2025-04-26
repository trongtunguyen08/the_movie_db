import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb/core/models/movie_model.dart';
import 'package:tmdb/screens/now_playing/repositories/now_playing_repository.dart';

part 'now_playing_view_model.g.dart';

@riverpod
class NowPlayingViewModel extends _$NowPlayingViewModel {
  late NowPlayingRepository _nowPlayingRepository;
  int? _totalPages;
  int _currentPage = 1;
  final List<MovieModel> _movies = [];

  @override
  Future<List<MovieModel>> build() async {
    _nowPlayingRepository = ref.read(nowPlayingRepositoryProvider);
    await _loadInitial();
    return _movies;
  }

  Future<void> _loadInitial() async {
    _currentPage = 1;
    state = const AsyncValue.loading();

    final res = await _nowPlayingRepository.nowPlaying();

    res.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (data) {
        _movies.clear();
        _movies.addAll(data.$1);
        _totalPages = data.$2;
        state = AsyncValue.data(_movies);
      },
    );
  }

  Future<void> loadMore() async {
    if (_currentPage == _totalPages || state.isLoading) {
      return;
    }

    _currentPage++;
    final res = await _nowPlayingRepository.nowPlaying(page: _currentPage);

    res.fold(
      (failure) {
        _currentPage--;
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (data) {
        _movies.addAll(data.$1);
        _totalPages = data.$2;
        state = AsyncValue.data([..._movies]);
      },
    );
  }

  Future<void> onRefresh() async {
    await _loadInitial();
  }
}
