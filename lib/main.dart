import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_movie_db/core/theme/app_pallete.dart';
import 'package:the_movie_db/core/theme/db_app_theme.dart';
import 'package:the_movie_db/features/home/view/pages/home_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Pallete.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Movie DB',
      theme: DbAppTheme.darkThemeMode,
      home: HomePage(),
    );
  }
}
