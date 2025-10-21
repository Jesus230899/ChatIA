import 'package:bloc/bloc.dart';
import 'package:chatia/features/register/data/models/user_data_model.dart';
import 'package:chatia/features/register/domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterBloc({required this.registerUsecase})
    : super(RegisterState.initial()) {
    on<RegisterEvent>((event, emit) async {
      if (event is ChangeShowPasswordEvent) {
        emit(state.copyWith(showPassword: !state.showPassword));
      }
      if (event is ChangeShowConfirmPasswordEvent) {
        emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
      }

      if (event is RegisterRequestEvent) {
        await _onRegisterRequestEvent(emit, event);
      }
    });
  }

  Future<void> _onRegisterRequestEvent(
    Emitter<RegisterState> emit,
    RegisterRequestEvent event,
  ) async {
    await registerUsecase(
      UserDataModel(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      ),
    );
  }
}
