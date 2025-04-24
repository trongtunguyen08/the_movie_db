import 'package:the_movie_db/screens/movie_details/model/cast_model.dart';
import 'package:the_movie_db/screens/movie_details/model/video_model.dart';

class MovieDetailModel {
  final List<CastModel> casts;
  final VideoModel? video;

  const MovieDetailModel({required this.casts, required this.video});

  factory MovieDetailModel.empty() =>
      const MovieDetailModel(casts: [], video: null);
}
