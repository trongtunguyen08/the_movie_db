import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb/core/contants/app_contants.dart';
import 'package:tmdb/core/contants/server_contants.dart';
import 'package:tmdb/core/failure/app_failure.dart';
import 'package:tmdb/screens/movie_details/model/cast_model.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb/screens/movie_details/model/video_model.dart';

part 'movie_details_repository.g.dart';

@riverpod
MovieDetailsRepository movieDetailsRepository(Ref ref) {
  return MovieDetailsRepository();
}

class MovieDetailsRepository {
  Future<Either<AppFailure, List<CastModel>>> credits({
    required int movieId,
  }) async {
    final response = await http.get(
      Uri.parse(
        "${ServerContants.apiURL}/movie/$movieId/credits?language=${AppContants.apiLanguage}",
      ),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer ${AppContants.apiKey}",
      },
    );

    if (response.statusCode != 200) {
      return Left(AppFailure("Failed to get credits ${response.statusCode}"));
    }

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final results = responseJson["cast"] as List<dynamic>? ?? [];

    final cast =
        results
            .where((element) {
              return element is Map<String, dynamic> &&
                  element["profile_path"] != null;
            })
            .map((e) {
              return CastModel.fromMap(e);
            })
            .toList();
    return Right(cast);
  }

  Future<Either<AppFailure, VideoModel>> video({required int movieId}) async {
    final response = await http.get(
      Uri.parse(
        "${ServerContants.apiURL}/movie/$movieId/videos?language=${AppContants.apiLanguage}",
      ),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer ${AppContants.apiKey}",
      },
    );

    if (response.statusCode != 200) {
      return Left(AppFailure("Failed to get videos ${response.statusCode}"));
    }

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final results = responseJson["results"] as List<dynamic>? ?? [];

    final video = results
        .where(
          (element) =>
              element is Map<String, dynamic> &&
              element["site"]?.toString().toLowerCase() == "youtube",
        )
        .map((e) => VideoModel.fromMap(e))
        .firstWhere((video) => true);
    return Right(video);
  }
}
