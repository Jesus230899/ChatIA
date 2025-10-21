import 'package:chatia/core/validators/regex.dart';

class ValueValidator {
  static String? fullName(String? value) {
    if (value!.isEmpty) return 'El nombre es obligatorio.';
    if (!Regex.fullName(value)) return 'El nombre no es válido.';
    return null;
  }

  static String? email(String? value) {
    if (value!.isEmpty) return 'El correo es obligatorio.';
    if (!Regex.email(value)) return 'El correo no es válido.';
    return null;
  }

  static String? password(String? value) {
    if (value!.isEmpty) return 'La contraseña es obligatoria.';
    if (!Regex.password(value)) return 'La contraseña no es válida.';
    return null;
  }

  static String? confirmPassword(String? value, String? pass) {
    if (value!.isEmpty) return 'La contraseña es obligatoria.';
    if (value != pass) return 'Las contraseñas no coinciden.';
    return null;
  }
}
