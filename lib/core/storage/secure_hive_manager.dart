import 'dart:convert';
import 'package:chatia/core/storage/hive_boxes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Gestor seguro para Hive con cifrado AES
class SecureHiveManager {
  static final SecureHiveManager _instance = SecureHiveManager._internal();
  factory SecureHiveManager() => _instance;
  SecureHiveManager._internal();

  static const _secureStorage = FlutterSecureStorage();
  bool _initialized = false;

  /// Obtiene la clave AES de forma segura, o la genera si no existe
  Future<List<int>> _getEncryptionKey() async {
    const keyName = 'hive_encryption_key';
    String? base64Key = await _secureStorage.read(key: keyName);

    if (base64Key == null) {
      final key = Hive.generateSecureKey();
      base64Key = base64Encode(key);
      await _secureStorage.write(key: keyName, value: base64Key);
    }

    return base64Decode(base64Key);
  }

  /// Inicializa Hive y abre boxes con cifrado
  Future<void> init() async {
    if (_initialized) return;
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    // await Hive.initFlutter() ;

    final encryptionKey = await _getEncryptionKey();

    await Hive.openBox(
      HiveBoxes.geminiChats,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    _initialized = true;
  }

  Box getBox(String name) => Hive.box(name);


  Future<void> removeAllBoxes() async {
    for (final name in HiveBoxes.boxes) {
      if (await Hive.boxExists(name)) {
        await Hive.box(name).clear();
        await Hive.box(name).close();
      }
    }
  }
}
