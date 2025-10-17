import 'package:chatia/core/failure/failure.dart';
import 'package:chatia/generated/l10n.dart';
import 'package:chatia/core/utils/enums.dart';

class OperationFailure extends Failure{

  final String? message;
  final int?code;

  OperationFailure({this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  static OperationFailure mapError({required int? code, String? message}) {
    switch (code) {
      case ResponseCode.ok:
        return OperationFailure(
          message: message ?? S.current.solicitudProcesada,
          code: code,
        );
      case ResponseCode.resourceCreated:
        return OperationFailure(
          message: message ?? S.current.solicitudProcesadaCreada,
          code: code,
        );
      case ResponseCode.badRequest:
        return OperationFailure(
          message: message ?? S.current.solicitudNoProcesada,
          code: code,
        );
      case ResponseCode.unauthorized:
      case ResponseCode.forbidden:
        return OperationFailure(
          message: message ?? S.current.noAutorizacion,
          code: code,
        );

      case ResponseCode.notFound:
        return OperationFailure(
          message: message ?? S.current.consultaNoRealizada,
          code: code,
        );
      case ResponseCode.notAllowed:
        return OperationFailure(
          message: message ?? S.current.solicitudNoPermitida,
          code: code,
        );
      case ResponseCode.notAcceptable:
        return OperationFailure(
          message: message ?? S.current.solicitudNoAceptada,
          code: code,
        );
      case ResponseCode.conflict:
        return OperationFailure(
          message: message ?? S.current.solicitudConflicto,
          code: code,
        );
      case ResponseCode.gone:
        return OperationFailure(
          message: message ?? S.current.recursoNoDisponible,
          code: code,
        );
      case ResponseCode.serverError:
      case ResponseCode.notImplemented:
      case ResponseCode.serviceUnavailable:
        return OperationFailure(
          message: message ?? S.current.errorServidor,
          code: code,
        );
      default:
        return OperationFailure(
          message: message ?? '',
          code: code,
        );
    }
  }
}
