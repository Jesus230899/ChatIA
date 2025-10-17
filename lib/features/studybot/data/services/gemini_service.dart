import 'dart:convert';
import 'dart:developer';

import 'package:chatia/core/failure/operation_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;

enum GeminiStatus { idle, seraching, writing, error }

// Este servicio se encarga de interactuar con el modelo Gemini.
class GeminiService {
  final String _apikey = dotenv.env["GEMINI_KEY"] ?? '';
  final String _model = "gemini-2.5-flash";
  GeminiStatus status = GeminiStatus.idle;

  Future<Either<OperationFailure, String>> askGemini({
    required String prompot,
  }) async {
    try {
      status = GeminiStatus.seraching;
      // En este caso vamos a usar la pokeAPI
      final externalInfo = await _fetchPokeAPi(query: prompot);
      // Armamos el prompt que se enviará a Gemini

      String fullPrompt = '';

      if (externalInfo.isLeft()) {
        fullPrompt = '''
Eres un chatbot educativo especializado en temas de ciencia.
Responde únicamente sobre temas científicos (física, biología, química, astronomía, etc.).
Si el usuario pregunta algo fuera de ese ámbito, responde de manera amable:
"Lo siento, solo puedo responder preguntas relacionadas con la ciencia.". Tambien aplica si el usuario te pregunta sobre temas de cine, recetas, traduccion de frases. Tu solo eres un chatbot que ayuda con temas educativos.
Dicho lo anterior, el usuario preguntó $prompot, responde de manera clara y concisa a la pregunta del usuario.''';
      } else {
        final info = externalInfo.fold((l) => null, (r) => r);
        fullPrompt =
            '''
Eres un chatbot educativo especializado en temas de ciencia.
Responde únicamente sobre temas científicos (física, biología, química, astronomía, etc.).
Si el usuario pregunta algo fuera de ese ámbito, responde de manera amable:
"Lo siento, solo puedo responder preguntas relacionadas con la ciencia.". Tambien aplica si el usuario te pregunta sobre temas de cine, recetas, traduccion de frases. Tu solo eres un chatbot que ayuda con temas educativos.
Dicho lo anterior, el usuario preguntó $prompot. La información que se obtuvo de la web es: $info.
Usando esta información, responde de manera clara y concisa a la pregunta del usuario.''';
      }

      status = GeminiStatus.writing;
      final llmResponse = await _askGeminiLLM(prompt: fullPrompt);

      status = GeminiStatus.idle;
      return llmResponse;
      // return externalInfo;
    } catch (e) {
      status = GeminiStatus.error;
      return left(OperationFailure(message: "Error $e"));
    }
  }

  Future<Either<OperationFailure, String>> _askGeminiLLM({
    required String prompt,
  }) async {
    log('Entra en _askGeminiLLM');
    final endpoint =
        "https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent";

    log('El prompt enviado es $prompt');

    final Either<OperationFailure, http.Response> response = await retry(
      () async {
        final resp = await http.post(
          Uri.parse("$endpoint?key=$_apikey"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {"text": prompt},
                ],
              },
            ],
          }),
        );
        log(resp.toString());
        log('Gemini response: ${resp.body}');
        if (resp.statusCode != 200) {
          log(resp.body.toString());
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
    log('El query obtenido es $query');
    final name = _extractPokeName(query);
    log('El nombre extraído es $name');

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
      log('El response de pokeapi es ${response.body}');
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
