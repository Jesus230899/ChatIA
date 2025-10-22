part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool showPassword;
  final bool loading;
  final Option<Either<OperationFailure, UserDataModel>> loginResult;

  const LoginState({
    required this.showPassword,
    required this.loading,
    required this.loginResult,
  });

  LoginState copyWith({
    bool? showPassword,
    bool? loading,
    Option<Either<OperationFailure, UserDataModel>>? loginResult,
  }) => LoginState(
    showPassword: showPassword ?? this.showPassword,
    loading: loading ?? this.loading,
    loginResult: loginResult ?? this.loginResult,
  );

  factory LoginState.initial() =>
      LoginState(showPassword: false, loading: false, loginResult: none());

  @override
  List<Object> get props => [showPassword, loading, loginResult];
}
