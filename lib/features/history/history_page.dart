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
      appBar: AppBar(title: const Text("History")),
      body: FutureBuilder(
        future: _history,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading history: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(child: Text("No history yet"));
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
                onTap: () {
                  // Zoom in on tap
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          _ImageZoomScreen(imagePath: path, imageBytes: bytes),
                    ),
                  );
                },
                onLongPress: () async {
                  try {
                    await StorageService.toggleFavorite(path);
                    setState(() {
                      _history = StorageService.getHistory();
                    });
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Favorite toggled')),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: Hero(tag: path, child: buildImage(path, bytes)),
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

// Fullscreen zoom screen for history images
class _ImageZoomScreen extends StatelessWidget {
  final String imagePath;
  final Uint8List imageBytes;

  const _ImageZoomScreen({required this.imagePath, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Hero(
            tag: imagePath,
            child: Image.memory(imageBytes, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
