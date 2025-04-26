import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb/core/failure/app_failure.dart';
import 'package:tmdb/core/models/movie_model.dart';
import 'package:tmdb/screens/cast_info/model/cast_info_model.dart';
import 'package:tmdb/screens/cast_info/model/cast_info_response_model.dart';
import 'package:tmdb/screens/cast_info/repositories/cast_info_repository.dart';

part 'cast_info_view_model.g.dart';

@riverpod
class CastInfoViewModel extends _$CastInfoViewModel {
  late CastInfoRepository _castInfoRepository;
  @override
  Future<CastInfoResponseModel> build() async {
    _castInfoRepository = ref.read(castInfoRepositoryProvider);
    return CastInfoResponseModel.empty();
  }

  Future<void> loadCastInfo({required int castId}) async {
    state = AsyncValue.loading();

    final castInfoResponse = await _getCastInfo(castId: castId);
    final moviesCreditResponse = await _getMoviesCreditForCast(castId: castId);

    castInfoResponse.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (castInfo) {
        moviesCreditResponse.fold(
          (failure) {
            state = AsyncValue.error(failure.message, StackTrace.current);
          },
          (movies) {
            state = AsyncValue.data(
              CastInfoResponseModel(movies: movies, castInfo: castInfo),
            );
          },
        );
      },
    );
  }

  Future<Either<AppFailure, CastInfoModel>> _getCastInfo({
    required int castId,
  }) async {
    final res = await _castInfoRepository.castInfo(castId: castId);
    return res;
  }

  Future<Either<AppFailure, List<MovieModel>>> _getMoviesCreditForCast({
    required int castId,
  }) async {
    final res = await _castInfoRepository.movieCreditsForCast(castId: castId);
    return res;
  }
}
