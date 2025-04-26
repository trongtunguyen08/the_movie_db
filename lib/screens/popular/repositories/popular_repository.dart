import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmdb/core/contants/app_contants.dart';
import 'package:tmdb/core/contants/server_contants.dart';
import 'package:tmdb/core/failure/app_failure.dart';
import 'package:tmdb/core/models/movie_model.dart';
import 'package:http/http.dart' as http;

part 'popular_repository.g.dart';

@riverpod
PopularRepository popularRepository(Ref ref) {
  return PopularRepository();
}

class PopularRepository {
  Future<Either<AppFailure, (List<MovieModel>, int)>> popular({
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ServerContants.apiURL}/movie/popular?language=${AppContants.apiLanguage}&page=$page",
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
