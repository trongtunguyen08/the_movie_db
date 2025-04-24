import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_movie_db/core/contants/app_contants.dart';
import 'package:the_movie_db/core/contants/server_contants.dart';
import 'package:the_movie_db/core/failure/app_failure.dart';
import 'package:the_movie_db/core/models/movie_model.dart';

part 'now_playing_repository.g.dart';

@riverpod
NowPlayingRepository nowPlayingRepository(Ref ref) {
  return NowPlayingRepository();
}

class NowPlayingRepository {
  Future<Either<AppFailure, (List<MovieModel>, int)>> nowPlaying({
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ServerContants.apiURL}/movie/now_playing?language=${AppContants.apiLanguage}&page=$page",
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer ${AppContants.apiKey}",
        },
      );

      if (response.statusCode != 200) {
        return Left(
          AppFailure("Failed to get list movies ${response.statusCode}"),
        );
      }

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      final results = responseJson["results"] as List<dynamic>? ?? [];
      final totalPages = responseJson["total_pages"] as int? ?? 1;

      final movies = results.map((e) => MovieModel.fromMap(e)).toList();
      return Right((movies, totalPages));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
