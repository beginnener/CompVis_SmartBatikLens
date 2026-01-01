import 'package:flutter/material.dart';
import '../../shared/constant/app_colors.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(child: Text('Favorit Page Content')),
    );
  }
}
