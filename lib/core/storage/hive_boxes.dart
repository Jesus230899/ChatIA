import 'package:flutter_dotenv/flutter_dotenv.dart';

// Nombres de las boxes que se usan en Hive
class HiveBoxes {
  static final geminiChats = dotenv.env['HIVE_BOX_CHATS'] ?? 'gemini_chats';

  static final boxes = [geminiChats];
}
