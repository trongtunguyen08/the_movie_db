import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  Future<Either<AppFailure, List<MovieModel>>> fetchNowPlaying() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ServerContants.apiURL}/movie/now_playing?language=en-US&page=1",
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer ${AppContants.apiKey}",
        },
      );
      final resJsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (kDebugMode) {
        print(resJsonBody);
      }
      return Right(resJsonBody as List<MovieModel>);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
