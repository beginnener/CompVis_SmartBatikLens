import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _historyKey = 'photo_history';
  static const _favoritesKey = 'favorites';

  /// Simpan foto ke histori
  static Future<void> addToHistory({
    required String path,
    required Uint8List bytes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];

    history.add(jsonEncode({
      "path": path,
      "bytes": base64Encode(bytes),
    }));

    await prefs.setStringList('history', history);
  }

  // ambil histori foto
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];

    return history.map((e) {
      final data = jsonDecode(e);
      return {
        "path": data["path"],
        "bytes": base64Decode(data["bytes"]),
      };
    }).toList();
  }

  /// tambahkan ke favorit atau hapus dari favorit
  static Future<void> toggleFavorite(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey) ?? [];

    list.contains(path) ? list.remove(path) : list.add(path);

    await prefs.setStringList(_favoritesKey, list);
  }

 static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("favorites") ?? [];

    return Future.wait(list.map((path) async {
      Uint8List bytes;

      if (kIsWeb) {
        bytes = await _readBytesWeb(path);
      } else {
        bytes = await File(path).readAsBytes();
      }

      return {
        "path": path,
        "bytes": bytes,
      };
    }));
  }

  // cek apakah foto ada di favorit
  static Future<bool> isFavorite(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey) ?? [];
    return list.contains(path);
  }

  // Membaca bytes di Web (misalnya dari blob / object URL)
  static Future<Uint8List> _readBytesWeb(String path) async {
    final uri = Uri.parse(path);
    final response = await http.get(uri);
    return response.bodyBytes;
  }
}

