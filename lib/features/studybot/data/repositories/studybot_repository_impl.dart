import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/data/services/gemini_service.dart';
import 'package:chatia/features/studybot/domain/repositories/studybot_repository.dart';
import 'package:dartz/dartz.dart';

class StudybotRepositoryImpl extends StudybotRepository {
  final GeminiService geminiService;
  StudybotRepositoryImpl({required this.geminiService});

  @override
  Future<Either<OperationFailure, String>> askGemini({
    required String prompt,
  }) async {
    return await geminiService.askGemini(prompot: prompt);
  }
}
