import 'package:flutter/material.dart';
import 'package:the_movie_db/core/contants/server_contants.dart';
import 'package:the_movie_db/core/models/movie_model.dart';

class MovieDetailsPage extends StatefulWidget {
  final MovieModel movie;
  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: movie.posterPath,
                child: Image.network(
                  "${ServerContants.apiImageURL}${movie.posterPath}",
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
