import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:dartz/dartz.dart';

// Esta interfaz define el contrato para el repositorio que maneja las interacciones con el modelo Gemini.
// Al definir un repositorio abstracto, podemos cambiar la implementación concreta sin afectar las capas superiores.
// Esto es fundamental para mantener una arquitectura limpia y desacoplada.
abstract class StudybotLocalRepository {
  // Either se utiliza para manejar tanto el resultado exitoso(Unit) como los posibles errores(OperationFailure) de manera funcional.
  Future<Either<OperationFailure, Unit>> saveChat({
    required GeminiChatModel chat,
  });

  Future<Either<OperationFailure, List<GeminiChatModel>>> getAllChats();

  Future<Either<OperationFailure, Unit>> deleteAllChats();
}
