import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_movie_db/core/models/movie_model.dart';
import 'package:the_movie_db/screens/popular/repositories/popular_repository.dart';

part 'popular_view_model.g.dart';

@riverpod
class PopularViewModel extends _$PopularViewModel {
  late PopularRepository _popularRepository;
  int? _totalPages;
  int _currentPage = 1;
  final List<MovieModel> _movies = [];

  @override
  Future<List<MovieModel>> build() async {
    _popularRepository = ref.read(popularRepositoryProvider);
    await _initialLoad();
    return _movies;
  }

  Future<void> _initialLoad() async {
    _currentPage = 1;
    state = AsyncValue.loading();

    final res = await _popularRepository.popular();

    res.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (data) {
        _totalPages = data.$2;
        _movies.addAll(data.$1);
        state = AsyncValue.data(_movies);
      },
    );
  }

  Future<void> loadMore() async {
    if (_currentPage == _totalPages || state.isLoading) {
      return;
    }

    _currentPage++;
    final res = await _popularRepository.popular(page: _currentPage);

    res.fold(
      (failure) {
        _currentPage--;
      },
      (data) {
        _totalPages = data.$2;
        _movies.addAll(data.$1);
        state = AsyncValue.data([..._movies]);
      },
    );
  }

  Future<void> onRefresh() async {
    await _initialLoad();
  }
}
