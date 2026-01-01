import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../features/splash/splash_screen.dart';
import '../features/lens/presentation/lens_screen.dart';
import '../features/history/history_page.dart';
import '../features/favorites/favorite_page.dart';
import '../shared/constant/app_colors.dart';

class SmartBatikApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const SmartBatikApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Batik Lens',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
      ),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/camera':
            return MaterialPageRoute(
              builder: (_) => LensScreen(cameras: cameras),
            );
          case '/history':
            return MaterialPageRoute(builder: (_) => const HistoryPage());
          case '/favorites':
            return MaterialPageRoute(builder: (_) => const FavoritesPage());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
