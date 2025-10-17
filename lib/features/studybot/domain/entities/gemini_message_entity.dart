import 'package:equatable/equatable.dart';

// Usamos Equatable para facilitar la comparación de objetos
class GeminiMessageEntity extends Equatable {
  final bool isUser;
  final String message;
  final DateTime? date;

  const GeminiMessageEntity({required this.isUser, required this.message, this.date});

  @override
  List<Object?> get props => [isUser, message, date];
}
