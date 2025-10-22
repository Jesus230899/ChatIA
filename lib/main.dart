import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/main_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Inyectar todas las dependencias
  await injectDependencies();

  runApp(const MyApp());
}
