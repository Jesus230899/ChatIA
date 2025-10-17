// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "consultaNoRealizada": MessageLookupByLibrary.simpleMessage(
      "Query not getting executed",
    ),
    "errorDesconocido": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "errorServidor": MessageLookupByLibrary.simpleMessage(
      "The server is temporarily unavailable",
    ),
    "noAutorizacion": MessageLookupByLibrary.simpleMessage(
      "You do not have authorization to make this request",
    ),
    "recursoNoDisponible": MessageLookupByLibrary.simpleMessage(
      "The requested resource is no longer on the server",
    ),
    "solicitudConflicto": MessageLookupByLibrary.simpleMessage(
      "The request could not be completed due to a conflict in the request",
    ),
    "solicitudNoAceptada": MessageLookupByLibrary.simpleMessage(
      "The request is unacceptable",
    ),
    "solicitudNoPermitida": MessageLookupByLibrary.simpleMessage(
      "The request is not allowed",
    ),
    "solicitudNoProcesada": MessageLookupByLibrary.simpleMessage(
      "The request cannot be processed",
    ),
    "solicitudProcesada": MessageLookupByLibrary.simpleMessage(
      "The request has been processed successfully",
    ),
    "solicitudProcesadaCreada": MessageLookupByLibrary.simpleMessage(
      "The request has been processed successfully, and the resource has been created",
    ),
  };
}
