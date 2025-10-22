import 'dart:convert';

import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/http/http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:retry/retry.dart';


// Este servicio se encarga de interactuar con el modelo Gemini.
class GeminiApiService {
  final HTTPClient client;
  final String apiKey;
  final String pathURL;

  GeminiApiService({
    required this.client,
    required this.apiKey,
    required this.pathURL,
  });

  Future<Either<OperationFailure, String>> call({required Object body}) async {
    try {
      // Retry para reintentar la solicitud en caso de fallos transitorios
      final response = await retry(
        () =>
            client.post(pathURL, body: body, queryParameters: {"key": apiKey}),
        maxAttempts: 3,
      );
      if (response.statusCode != 200) {
        return left(
          OperationFailure(
            code: response.statusCode,
            message: "Error al contactar con Gemini",
          ),
        );
      }
      final data = jsonDecode(response.body);
      // Obtener la respuesta de texto del modelo Gemini
      final textResponse =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (textResponse == null) {
        return left(OperationFailure(message: 'Respuesta inválida de Gemini'));
      }

      return right(textResponse);
    } catch (e) {
      return left(OperationFailure(message: 'Error al contactar Gemini'));
    }
  }
}
