import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_movie_db/screens/movie_details/model/movie_detail_model.dart';
import 'package:the_movie_db/screens/movie_details/repositories/movie_details_repository.dart';

part 'movie_details_view_model.g.dart';

@riverpod
class MovieDetailsViewModel extends _$MovieDetailsViewModel {
  late MovieDetailsRepository _movieDetailsRepository;

  @override
  Future<MovieDetailModel> build() async {
    _movieDetailsRepository = ref.read(movieDetailsRepositoryProvider);
    return MovieDetailModel.empty();
  }

  Future<void> loadMovieDeatils({required int movieId}) async {
    state = const AsyncValue.loading();

    final creditsResponse = await _movieDetailsRepository.credits(
      movieId: movieId,
    );
    final videoResponse = await _movieDetailsRepository.video(movieId: movieId);

    creditsResponse.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (casts) {
        videoResponse.fold(
          (failure) {
            state = AsyncValue.error(failure.message, StackTrace.current);
          },
          (video) {
            state = AsyncValue.data(
              MovieDetailModel(casts: casts, video: video),
            );
          },
        );
      },
    );
  }
}
