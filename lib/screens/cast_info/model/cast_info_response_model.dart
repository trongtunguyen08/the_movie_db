import 'package:tmdb/core/models/movie_model.dart';
import 'package:tmdb/screens/cast_info/model/cast_info_model.dart';

class CastInfoResponseModel {
  final CastInfoModel? castInfo;
  final List<MovieModel> movies;

  CastInfoResponseModel({this.castInfo, required this.movies});

  factory CastInfoResponseModel.empty() =>
      CastInfoResponseModel(movies: [], castInfo: null);
}
