part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool showPassword;
  final bool loading;
  final bool showConfirmPassword;
  final Option<Either<OperationFailure, UserDataModel>> registerResult;

  const RegisterState({
    required this.showPassword,
    required this.showConfirmPassword,
    required this.loading,
    required this.registerResult,
  });

  RegisterState copyWith({
    bool? showPassword,
    bool? showConfirmPassword,
    bool? loading,
    Option<Either<OperationFailure, UserDataModel>>? registerResult,
  }) => RegisterState(
    showPassword: showPassword ?? this.showPassword,
    showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    loading: loading ?? this.loading,
    registerResult: registerResult ?? this.registerResult,
  );

  factory RegisterState.initial() => RegisterState(
    showPassword: false,
    showConfirmPassword: false,
    loading: false,
    registerResult: none(),
  );

  @override
  List<Object> get props => [
    showPassword,
    showConfirmPassword,
    loading,
    registerResult,
  ];
}
