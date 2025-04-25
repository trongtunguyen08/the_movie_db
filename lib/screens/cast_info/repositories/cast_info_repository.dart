import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_movie_db/core/contants/app_contants.dart';
import 'package:the_movie_db/core/contants/server_contants.dart';
import 'package:the_movie_db/core/failure/app_failure.dart';
import 'package:the_movie_db/core/models/movie_model.dart';
import 'package:the_movie_db/screens/cast_info/model/cast_info_model.dart';
import 'package:http/http.dart' as http;

part 'cast_info_repository.g.dart';

@riverpod
CastInfoRepository castInfoRepository(Ref ref) {
  return CastInfoRepository();
}

class CastInfoRepository {
  Future<Either<AppFailure, CastInfoModel>> castInfo({
    required int castId,
  }) async {
    final response = await http.get(
      Uri.parse(
        "${ServerContants.apiURL}/person/$castId?language=${AppContants.apiLanguage}",
      ),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer ${AppContants.apiKey}",
      },
    );

    if (response.statusCode != 200) {
      return Left(AppFailure("Failed to get cast info ${response.statusCode}"));
    }

    final result = jsonDecode(response.body) as Map<String, dynamic>;

    final castInfo = CastInfoModel.fromMap(result);
    return Right(castInfo);
  }

  Future<Either<AppFailure, List<MovieModel>>> movieCreditsForCast({
    required int castId,
  }) async {
    final response = await http.get(
      Uri.parse(
        "${ServerContants.apiURL}/person/$castId/movie_credits?language=${AppContants.apiLanguage}",
      ),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer ${AppContants.apiKey}",
      },
    );

    if (response.statusCode != 200) {
      return Left(
        AppFailure("Failed to get movie credits ${response.statusCode}"),
      );
    }

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final results = responseJson["cast"] as List<dynamic>? ?? [];

    final movies = results.map((e) => MovieModel.fromMap(e)).toList();
    return Right(movies);
  }
}
