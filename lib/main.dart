import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/storage/secure_hive_manager.dart';
import 'package:chatia/features/studybot/data/datasources/local/studybot_local_datasource_impl.dart';
import 'package:chatia/main_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");
  // Inicializa Hive globalmente
  await Hive.initFlutter();

  // Inyectar todas las dependencias
  await injectDependencies();

  runApp(const MyApp());
}
