import 'dart:developer';

import 'package:chatia/features/studybot/di/studybot_injection.dart';
import 'package:get_it/get_it.dart';

// Aqui se crea la instancia global de GetIt para la inyección de dependencias que será llamada en main.dart y podrá ser usada en toda la app.
final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // Esto crea un nuevo scope para las inyecciones de dependencias, lo que ayuda a gestionar el ciclo de vida de los objetos inyectados.
  getIt.pushNewScope();

  // Creamos una lista de todas las funciones de inyección de dependencias de cada feature.
  final injections = [initStudybotInjection];

  await Future.wait(
    injections.map((inject) async {
      try {
        await inject();
      } catch (e) {
        log('Error injecting dependencies for ${inject.toString()}: $e');
      }
    }),
  );
}

// Esta función elimina una instancia registrada en GetIt si ya existe, evitando conflictos o duplicaciones.
void removeRegistrationIfExist<T extends Object>({String? instaceName}) {
  if (getIt.isRegistered<T>(instance: instaceName)) {
    getIt.unregister<T>(instance: instaceName);
  }
}
