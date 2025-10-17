import 'dart:convert';
import 'dart:developer';

import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/constants/gemini_prompts.dart';
import 'package:chatia/features/studybot/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;

enum GeminiStatus { idle, seraching, writing, error }

// Este servicio se encarga de interactuar con el modelo Gemini.
class GeminiRemoteDatasourceImpl implements GeminiRemoteDatasource {
  final String _apikey = dotenv.env["GEMINI_KEY"] ?? '';
  final String _baseURL = "generativelanguage.googleapis.com";
  final String _pathURL = "/v1beta/models/gemini-2.5-flash:generateContent";

  GeminiStatus status = GeminiStatus.idle;

  @override
  Future<Either<OperationFailure, GeminiChatModel>> askGemini({
    required GeminiChatModel chat,
  }) async {
    try {
      status = GeminiStatus.seraching;
      // Se debe de obtener el último mensaje del usuario para generar la respuesta
      final message = chat.contents.last.message;
      // En este caso vamos a usar la pokeAPI
      // final externalInfo = await _fetchPokeAPi(query: message);

      // Determinamos si la Gemini ha respondido anteriormente, en caso de que no, debemos decir que es el primer mensaje para que se agrege el prompt que indica como debe de actuar.
      final responsesByIA = chat.contents
          .where((e) => e.isUser == false)
          .length;

      // Armamos el prompt que se enviará a Gemini
      String fullPrompt = GeminiPrompts.studyBotPrompt(
        prompt: message,
        // externalInfo: externalInfo.fold((l) => null, (r) => r),
        externalInfo: null,
        responseByIA: responsesByIA > 0,
      );
      log('El fullPrompt es: $fullPrompt');

      // Aqui debemos de actualizar el chat con el prompt completo, solo se debe de actualizar el ultimo mensaje del usuario
      final GeminiMessageModel lastMessage = GeminiMessageModel.fromEntity(
        chat.contents.last,
      );

      final updatedMessages = List<GeminiMessageModel>.from(chat.contents)
        ..removeLast()
        ..add(lastMessage.copyWith(message: fullPrompt));

      final chatWithPrompt = chat.copyWith(contents: updatedMessages);

      // Finalmente se hace la consulta a Gemini
      status = GeminiStatus.writing;
      final llmResponse = await _askGeminiLLM(chat: chatWithPrompt);

      status = GeminiStatus.idle;
      if (llmResponse.isLeft()) {
        return left(
          llmResponse.fold((l) => l, (r) => OperationFailure(message: '')),
        );
      }
      return right(
        GeminiChatModel(
          contents: [
            ...chatWithPrompt.contents,
            GeminiMessageModel(
              isUser: false,
              message: llmResponse.fold((l) => '', (r) => r),
              date: DateTime.now(),
            ),
          ],
        ),
      );
      // return externalInfo;
    } catch (e) {
      log(e.toString());
      status = GeminiStatus.error;
      return left(OperationFailure(message: "Error $e"));
    }
  }

  Future<Either<OperationFailure, String>> _askGeminiLLM({
    required GeminiChatModel chat,
  }) async {
    log('Mensaje que se le manda a Gemini: ${chat.toJsonGemini()}');
    final Either<OperationFailure, http.Response> response = await retry(
      () async {
        final resp = await http.post(
          Uri(
            host: _baseURL,
            scheme: "https",
            path: _pathURL,
            queryParameters: {"key": _apikey},
          ),
          headers: {'Content-Type': 'application/json'},

          body: jsonEncode(chat.toJsonGemini()),
        );
        // log(resp.toString());
        // log('Gemini response: ${resp.body}');
        if (resp.statusCode != 200) {
          // log(resp.body.toString());
          return left(
            OperationFailure(code: resp.statusCode, message: resp.body),
          );
        }
        return right(resp);
      },
      maxAttempts: 3,
    );
    if (response.isRight()) {
      final result = response.fold((l) => null, (r) => r);
      final body = jsonDecode(result!.body);
      final textResponse =
          body['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return textResponse != null
          ? right(textResponse)
          : left(
              OperationFailure(code: 500, message: 'No response from Gemini'),
            );
    }
    return left(response.fold((l) => l, (r) => OperationFailure(message: '')));
  }

  Future<Either<OperationFailure, String>> _fetchPokeAPi({
    required String query,
  }) async {
    // log('El query obtenido es $query');
    final name = _extractPokeName(query);
    // log('El nombre extraído es $name');

    if (name == null) {
      return left(
        OperationFailure(
          message: 'No se encontró un nombre de Pokémon en la consulta.',
        ),
      );
    }
    try {
      final response = await http.get(
        Uri.parse("https://pokeapi.co/api/v2/pokemon/$name"),
      );
      // log('El response de pokeapi es ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'];
        final height = data['height'];
        final weight = data['weight'];
        final types = (data['types'] as List)
            .map((t) => t['type']['name'])
            .join(', ');

        return right(
          'El Pokémon $name tiene una altura de $height, un peso de $weight y es de tipo $types.',
        );
      } else {
        return left(
          OperationFailure(
            code: response.statusCode,
            message: 'Error al obtener datos del Pokémon.',
          ),
        );
      }
    } catch (e) {
      return left(
        OperationFailure(message: 'Error al obtener datos del Pokémon.'),
      );
    }
  }

  String? _extractPokeName(String text) {
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    for (final w in words) {
      if (w.length > 2) return w; // simplificación básica
    }
    return null;
  }
}
