import 'dart:convert';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/http/http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:retry/retry.dart';

// Este servicio se encarga de interactuar con la PokeAPI.
class PokeApiService {
  final HTTPClient client;
  PokeApiService({required this.client});

  Future<Either<OperationFailure, String>> fetchPokemon(String query) async {
    try {
      final response = await retry(
        () => client.get('/api/v2/pokemon/${query.toLowerCase()}'),
        maxAttempts: 3,
      );

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
      }

      return left(
        OperationFailure(
          code: response.statusCode,
          message: 'Error al obtener datos del Pokémon.',
        ),
      );
    } catch (e) {
      return left(
        OperationFailure(message: 'Error al obtener datos del Pokémon.'),
      );
    }
  }
}
