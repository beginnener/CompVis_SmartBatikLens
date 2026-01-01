import 'package:flutter/material.dart';
import '../../shared/constant/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/camera'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/logo_smartbatik.png', width: 200),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}