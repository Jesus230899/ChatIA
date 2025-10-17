import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_repository.dart';
import 'package:dartz/dartz.dart';

// Esta clase concreta implementa el caso de uso para interactuar con el modelo Gemini.
// A través de la inyección de dependencias, recibe un repositorio que maneja la lógica de datos.
// De esta forma logramos conectar la capa de dominio con la capa de presentacion sin acoplarlas directamente.
// Si requirierramos más parámetros, podríamos definir una clase Params para este caso de uso.

class AskGeminiUseCase implements UseCase<GeminiChatModel, GeminiChatModel> {
  final StudybotRepository repository;

  AskGeminiUseCase({required this.repository});

  @override
  Future<Either<OperationFailure, GeminiChatModel>> call(GeminiChatModel params) async {
    final result = await repository.askGemini(chat: params);
    return result;
  }
}
