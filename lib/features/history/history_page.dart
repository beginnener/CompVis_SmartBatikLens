import 'package:flutter/material.dart';
import '../../shared/constant/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(child: Text('Histori Page Content')),
    );
  }
}
