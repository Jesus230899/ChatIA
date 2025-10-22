import 'dart:developer';

import 'package:chatia/core/http/http_client_injection.dart';
import 'package:chatia/features/auth/di/auth_injection.dart';
import 'package:chatia/features/home/di/home_injection.dart';
import 'package:chatia/features/studybot/di/studybot_injection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

// Aqui se crea la instancia global de GetIt para la inyección de dependencias que será llamada en main.dart y podrá ser usada en toda la app.
final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // Creamos una lista de todas las funciones de inyección de dependencias de cada feature.
  final injections = [
    initSecureStorageInjection,
    initHTTPClientInjection,
    initStudybotInjection,
    initAuthInjection,
    initHomeInjection,
  ];

  for (final inject in injections) {
    try {
      await inject();
    } catch (e) {
      log('Error injectando dependencias ${inject.toString()}: $e');
    }
  }
}

// Esta función elimina una instancia registrada en GetIt si ya existe, evitando conflictos o duplicaciones.
void removeRegistrationIfExist<T extends Object>({String? instaceName}) {
  if (getIt.isRegistered<T>(instance: instaceName)) {
    getIt.unregister<T>(instance: instaceName);
  }
}

Future<void> initSecureStorageInjection() async {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Evita duplicados
  if (!getIt.isRegistered<FlutterSecureStorage>()) {
    getIt.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
  }
}
