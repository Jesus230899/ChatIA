import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/http/http_client.dart';
import 'package:chatia/features/studybot/data/constants/gemini_prompts.dart';
import 'package:chatia/features/studybot/data/datasources/remote/gemini_api_service.dart';
import 'package:chatia/features/studybot/data/datasources/remote/gemini_prompt_builder.dart';
import 'package:chatia/features/studybot/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:chatia/features/studybot/data/datasources/remote/poke_api_service.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


// Este servicio se encarga de interactuar con el modelo Gemini.
class GeminiRemoteDatasourceImpl implements GeminiRemoteDatasource {
  final GeminiApiService geminiAPI;
  final PokeApiService pokeAPI;
  final HTTPClient geminiClient = HTTPClient(
    baseURL: "generativelanguage.googleapis.com",
  );
  GeminiRemoteDatasourceImpl()
    : geminiAPI = GeminiApiService(
        client: HTTPClient(baseURL: "generativelanguage.googleapis.com"),
        apiKey: dotenv.env["GEMINI_KEY"] ?? '',
        pathURL: "/v1beta/models/gemini-2.5-flash:generateContent",
      ),
      pokeAPI = PokeApiService(client: HTTPClient(baseURL: 'pokeapi.co'));

  @override
  Future<Either<OperationFailure, GeminiChatModel>> askGemini({
    required GeminiChatModel chat,
  }) async {
    try {
      // Se debe de obtener el último mensaje del usuario para generar la respuesta
      final message = chat.contents.last.message;

      // Obtener informacion externa (PokeAPI)
      final externalInfo = await _externalPokeInfo(message);

      // Creamos el prompt completo
      final chatWithPrompt = GeminiPromptBuilder.buildPromptChat(
        chat: chat,
        userMessage: message,
        externalInfo: externalInfo,
      );

      // Llamamos a Gemini
      final llmResponse = await geminiAPI.call(
        body: chatWithPrompt.toJsonGemini(),
      );
      if (llmResponse.isLeft()) {
        return left(llmResponse.fold((l) => l, (r) => OperationFailure()));
      }

      // Construimos el nuevo chat con la respuesta de Gemini
      return right(
        GeminiChatModel(
          id: chat.id,
          contents: [
            ...chatWithPrompt.contents,
            GeminiMessageModel(
              isUser: false,
              message: llmResponse.fold((l) => '', (r) => r),
              date: DateTime.now().toString(),
            ),
          ],
        ),
      );
    } catch (e) {
      return left(
        OperationFailure(message: "Hubo un error al contactar Gemini"),
      );
    }
  }

  Future<String> _externalPokeInfo(String message) async {
    final resultGetPokemonName = await geminiAPI.call(
      body: {
        'contents': [
          {
            'role': 'user',
            'parts': {'text': GeminiPrompts.getPokemonName(question: message)},
          },
        ],
      },
    );

    final pokeName = resultGetPokemonName.fold((l) => null, (r) => r);
    String externalInfo = '';

    if (pokeName != null && pokeName.isNotEmpty && pokeName != '#no_pokemon') {
      final pokeResult = await pokeAPI.fetchPokemon(pokeName);
      externalInfo = pokeResult.fold((l) => '', (r) => r);
    }
    return externalInfo;
  }

  @override
  Future<Either<OperationFailure, String>> getChatName({
    required List<String> questions,
  }) async {
    final body = {
      'contents': [
        {
          'role': 'user',
          'parts': {
            'text': GeminiPrompts.generateTitleChat(questions: questions),
          },
        },
      ],
    };
    return geminiAPI.call(body: body);
  }
}
