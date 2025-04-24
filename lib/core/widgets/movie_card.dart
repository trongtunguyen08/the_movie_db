import 'package:flutter/material.dart';
import 'package:the_movie_db/core/contants/server_contants.dart';
import 'package:the_movie_db/core/models/movie_model.dart';
import 'package:the_movie_db/screens/movie_details/view/movie_details_page.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MovieDetailsPage(movie: movie);
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(
              "${ServerContants.apiImageURL}${movie.posterPath}",
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(movie.releaseDate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
