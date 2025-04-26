import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb/core/contants/server_contants.dart';
import 'package:tmdb/core/models/movie_model.dart';
import 'package:tmdb/screens/cast_info/model/cast_info_model.dart';
import 'package:tmdb/screens/cast_info/view_model/cast_info_view_model.dart';
import 'package:readmore/readmore.dart';

class CastInfoPage extends ConsumerStatefulWidget {
  final int castId;
  const CastInfoPage({super.key, required this.castId});

  @override
  ConsumerState<CastInfoPage> createState() => _CastInfoPageState();
}

class _CastInfoPageState extends ConsumerState<CastInfoPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(castInfoViewModelProvider.notifier)
          .loadCastInfo(castId: widget.castId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final castInfoState = ref.watch(castInfoViewModelProvider);

    return Scaffold(
      appBar: AppBar(),
      body: castInfoState.when(
        data: (data) {
          final CastInfoModel? castInfo = data.castInfo;
          final List<MovieModel> movies = data.movies;

          if (castInfo == null) {
            return const Center(child: Text("No cast information available"));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Render cast info
                Image.network(
                  "${ServerContants.apiOriginalImageURL}${castInfo.profilePath}",
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(castInfo.name),
                      const Text("Biography"),
                      ReadMoreText(
                        '${castInfo.biography} ',
                        colorClickableText: Colors.white,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Personal Info"),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const Text("Known For"),
                          Text(castInfo.name),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Birthday"),
                          Text(castInfo.birthday),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Place of Birth"),
                          Text(castInfo.placeOfBirth),
                        ],
                      ),
                      Column(
                        children: [const Text("Also Known As"), Text('-')],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          );
        },
        error: (error, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("error $error"),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(castInfoViewModelProvider);
                },
                child: const Text("Retry!"),
              ),
            ],
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
