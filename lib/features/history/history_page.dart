import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../lens/services/storage_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _history;

  @override
  void initState() {
    super.initState();
    _history = StorageService.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histori")),
      body: FutureBuilder(
        future: _history,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(child: Text("Belum ada histori"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final path = items[i]["path"] as String;
              final bytes = items[i]["bytes"] as Uint8List;

              return GestureDetector(
                onLongPress: () async {
                  await StorageService.toggleFavorite(path);
                  setState(() {});
                },
                child: Hero(
                  tag: path,
                  child: buildImage(path, bytes),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildImage(String path, Uint8List bytes) {
    if (kIsWeb) {
      return Image.memory(bytes, fit: BoxFit.cover);
    }

    return Image.file(File(path), fit: BoxFit.cover);
  }
}