import 'package:flutter/material.dart';

class PosterSkeletonWidget extends StatelessWidget {
  const PosterSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
