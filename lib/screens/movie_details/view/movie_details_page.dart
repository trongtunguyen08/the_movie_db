import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb/core/contants/server_contants.dart';
import 'package:tmdb/core/models/movie_model.dart';
import 'package:tmdb/screens/cast_info/view/cast_info_page.dart';
import 'package:tmdb/screens/movie_details/view_model/movie_details_view_model.dart';
import 'package:tmdb/screens/movie_details/widgets/poster_skeleton_widget.dart';
import 'package:tmdb/screens/movie_details/widgets/youtube_player_widget.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  final MovieModel movie;
  const MovieDetailsPage({super.key, required this.movie});

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(movieDetailsViewModelProvider.notifier)
          .loadMovieDeatils(movieId: widget.movie.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final movieDetailsAsync = ref.watch(movieDetailsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "${ServerContants.apiOriginalImageURL}${movie.posterPath}",
              fit: BoxFit.fill,
              width: double.infinity,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: frame != null ? child : PosterSkeletonWidget(),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(movie.overview, style: TextStyle(fontSize: 16.0)),
                  Text(movie.releaseDate),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            // Display casts section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Cast',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6.0),
            movieDetailsAsync.when(
              data: (data) {
                if (data.casts.isEmpty) {
                  return const Text('No cast information available');
                }
                return SizedBox(
                  height: 104.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: data.casts.length,
                    itemBuilder: (context, index) {
                      final cast = data.casts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CastInfoPage(castId: cast.id);
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 100.0,
                          margin: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "${ServerContants.apiImageURL}${cast.profilePath}",
                                ),
                                radius: 40,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                cast.name,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, _) {
                return Text('Error: $error');
              },
              loading: () {
                return const CircularProgressIndicator();
              },
            ),

            // Display video section
            const SizedBox(height: 12.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trailer',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  movieDetailsAsync.when(
                    data: (data) {
                      final video = data.video;
                      if (video == null) {
                        return const Text('No trailer available.');
                      }
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.video_library),
                            title: Text(video.name),
                          ),
                          YoutubePlayerWidget(videoId: video.key),
                        ],
                      );
                    },
                    error: (error, stackTrace) {
                      return Text('Error: $error');
                    },
                    loading: () {
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
