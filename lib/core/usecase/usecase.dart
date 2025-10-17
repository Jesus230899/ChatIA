import 'package:chatia/core/failure/operation_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

// Esta clase abstracta define un caso de uso genérico que toma un tipo de retorno y parámetros.
abstract class UseCase<T, Params> {

  // El método call ejecuta el caso de uso y devuelve un Either que contiene un OperationFailure o el tipo esperado.
  // El uso de Either permite manejar errores de manera funcional.
  Future<Either<OperationFailure, T>> call(Params params);
}

// En algunos casos, un caso de uso puede no requerir parámetros.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
