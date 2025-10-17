import 'package:equatable/equatable.dart';

// This is the base class for all failures in the application.
abstract class Failure extends Equatable {}

// This class represents a failure that contains an error object and an optional message.
class ErrorFailure extends Failure {
  final Object? error;
  final String? message;

  ErrorFailure({this.message, this.error});

  @override
  List<Object?> get props => [error, message];
}
