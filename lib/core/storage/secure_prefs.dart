import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurePrefs {
  final FlutterSecureStorage _storage;

  SecurePrefs._internal(this._storage);

  static final SecurePrefs _instance = SecurePrefs._internal(
    const FlutterSecureStorage(),
  );

  static SecurePrefs get instance => _instance;

  /// Guarda una lista de objetos JSON
  Future<void> setObjectList<T>(
    String key,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final jsonString = jsonEncode(items.map(toJson).toList());
    await _storage.write(key: key, value: jsonString);
  }

  /// Obtiene una lista de objetos JSON
  Future<List<T>> getObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final value = await _storage.read(key: key);
    if (value == null) return [];
    final decoded = jsonDecode(value) as List;
    return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Elimina una clave
  Future<void> remove(String key) async => _storage.delete(key: key);

  /// Limpia todo el almacenamiento
  Future<void> clear() async => _storage.deleteAll();
}