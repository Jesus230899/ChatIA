// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "consultaNoRealizada": MessageLookupByLibrary.simpleMessage(
      "Consulta no realizada",
    ),
    "errorDesconocido": MessageLookupByLibrary.simpleMessage(
      "Error desconocido",
    ),
    "errorServidor": MessageLookupByLibrary.simpleMessage(
      "El servidor no está temporalmente disponible",
    ),
    "noAutorizacion": MessageLookupByLibrary.simpleMessage(
      "No tienes autorización para realizar esta petición",
    ),
    "recursoNoDisponible": MessageLookupByLibrary.simpleMessage(
      "El recurso solicitado ya no está en el servidor",
    ),
    "solicitudConflicto": MessageLookupByLibrary.simpleMessage(
      "La solicitud no se pudo completar debido a un conflicto en la solicitud",
    ),
    "solicitudNoAceptada": MessageLookupByLibrary.simpleMessage(
      "La solicitud no es aceptable",
    ),
    "solicitudNoPermitida": MessageLookupByLibrary.simpleMessage(
      "La solicitud no está permitida",
    ),
    "solicitudNoProcesada": MessageLookupByLibrary.simpleMessage(
      "La solicitud no puede ser procesada",
    ),
    "solicitudProcesada": MessageLookupByLibrary.simpleMessage(
      "La solicitud se ha procesado correctamente",
    ),
    "solicitudProcesadaCreada": MessageLookupByLibrary.simpleMessage(
      "La solicitud se ha procesado correctamente y el recurso ha insertado creado",
    ),
  };
}
