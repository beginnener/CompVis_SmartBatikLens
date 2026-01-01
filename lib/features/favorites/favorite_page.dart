import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../lens/services/storage_service.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorit")),
      body: FutureBuilder(
        future: StorageService.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(child: Text("Belum ada favorit"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final path = items[i]["path"];
              final bytes = items[i]["bytes"] as Uint8List;

              return Card(
                child: ListTile(
                  leading: _buildImage(path, bytes),
                  title: Text(path, overflow: TextOverflow.ellipsis),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildImage(String path, Uint8List bytes) {
    if (kIsWeb) {
      return Image.memory(bytes, width: 60, fit: BoxFit.cover);
    }

    return Image.file(File(path), width: 60, fit: BoxFit.cover);
  }
}
