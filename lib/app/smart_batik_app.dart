import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/lens/presentation/lens_screen.dart';
import '../features/history/history_page.dart';
import '../features/favorites/favorite_page.dart';

class SmartBatikApp extends StatelessWidget {
  const SmartBatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Batik Lens',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF795548),
          primary: const Color(0xFF5D4037),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/camera': (context) => const LensScreen(),
        '/history': (context) => const HistoryPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
