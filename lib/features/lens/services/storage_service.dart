import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _historyKey = 'history';
  static const _favoritesKey = 'favorites';

  /// Save photo to history
  static Future<void> addToHistory({
    required String path,
    required Uint8List bytes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_historyKey) ?? [];

      history.add(jsonEncode({"path": path, "bytes": base64Encode(bytes)}));

      await prefs.setStringList(_historyKey, history);
    } catch (e) {
      throw Exception('Failed to save to history: $e');
    }
  }

  /// Get photo history
  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_historyKey) ?? [];

      return history.map((e) {
        final data = jsonDecode(e);
        return {"path": data["path"], "bytes": base64Decode(data["bytes"])};
      }).toList();
    } catch (e) {
      throw Exception('Failed to get history: $e');
    }
  }

  /// Add to favorites or remove from favorites
  static Future<void> toggleFavorite(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_favoritesKey) ?? [];

      list.contains(path) ? list.remove(path) : list.add(path);

      await prefs.setStringList(_favoritesKey, list);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  /// Get all favorited photos
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_favoritesKey) ?? [];

      return Future.wait(
        list.map((path) async {
          Uint8List bytes;

          if (kIsWeb) {
            bytes = await _readBytesWeb(path);
          } else {
            bytes = await File(path).readAsBytes();
          }

          return {"path": path, "bytes": bytes};
        }),
      );
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  /// Check if photo is favorited
  static Future<bool> isFavorite(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_favoritesKey) ?? [];
      return list.contains(path);
    } catch (e) {
      return false;
    }
  }

  /// Read bytes on Web platform (e.g., from blob/object URL)
  static Future<Uint8List> _readBytesWeb(String path) async {
    final uri = Uri.parse(path);
    final response = await http.get(uri);
    return response.bodyBytes;
  }
}
