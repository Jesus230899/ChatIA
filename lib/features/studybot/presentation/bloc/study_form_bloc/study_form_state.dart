part of 'study_form_bloc.dart';

class StudyFormState extends Equatable {
  final bool loading;
  final Option<UserDataModel> userData;
  final Option<Either<OperationFailure, UserDataModel>> userDataResult;
  final Option<Either<OperationFailure, Unit>> saveUserDataResult;
  final Option<Either<OperationFailure, Unit>> logOutResult;

  const StudyFormState({
    required this.loading,
    required this.userData,
    required this.userDataResult,
    required this.saveUserDataResult,
    required this.logOutResult,
  });

  StudyFormState copyWith({
    bool? loading,
    Option<UserDataModel>? userData,
    Option<Either<OperationFailure, UserDataModel>>? userDataResult,
    Option<Either<OperationFailure, Unit>>? saveUserDataResult,
    Option<Either<OperationFailure, Unit>>? logOutResult,
  }) => StudyFormState(
    loading: loading ?? this.loading,
    userData: userData ?? this.userData,
    userDataResult: userDataResult ?? this.userDataResult,
    saveUserDataResult: saveUserDataResult ?? this.saveUserDataResult,
    logOutResult: logOutResult ?? this.logOutResult,
  );
  factory StudyFormState.initial() => StudyFormState(
    loading: false,
    userData: none(),
    userDataResult: none(),
    saveUserDataResult: none(),
    logOutResult: none(),
  );

  @override
  List<Object> get props => [
    loading,
    userData,
    userDataResult,
    saveUserDataResult,
    logOutResult,
  ];
}
