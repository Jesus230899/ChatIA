import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/usecase/usecase.dart';
import 'package:chatia/features/auth/data/models/user_data_model.dart';
import 'package:chatia/features/studybot/domain/usecases/delete_all_chats_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'study_form_event.dart';
part 'study_form_state.dart';

class StudyFormBloc extends Bloc<StudyFormEvent, StudyFormState> {
  final DeleteAllChatsUsecase deleteAllChatsUsecase;
  StudyFormBloc({required this.deleteAllChatsUsecase})
    : super(StudyFormState.initial()) {
    on<StudyFormEvent>((event, emit) async {
      if (event is LoadUserDataEvent) {
        await _onLoadUserDataEvent(event, emit);
      }
      if (event is ChangeFullNameEvent) {
        _onChangeFullNameEvent(event, emit);
      }
      if (event is SaveChangesUserDataEvent) {
        await _onSaveChangesUserDataEvent(event, emit);
      }
      if (event is LogOutEvent) {
        await _onLogOutEvent(event, emit);
      }
    });
  }

  Future<void> _onLoadUserDataEvent(
    LoadUserDataEvent event,
    Emitter<StudyFormState> emit,
  ) async {
    emit(state.copyWith(loading: true, userDataResult: none()));
    final storage = getIt<FlutterSecureStorage>();
    final user = await storage.read(key: dotenv.env['USER_DATA']!);
    if (user != null) {
      final userData = UserDataModel.fromJson(jsonDecode(user));
      emit(
        state.copyWith(
          userData: some(userData),
          loading: false,
          userDataResult: optionOf(right(userData)),
        ),
      );
    } else {
      emit(
        state.copyWith(
          loading: false,
          userDataResult: optionOf(
            left(OperationFailure(message: 'Usuario no encontrado')),
          ),
        ),
      );
    }
  }

  void _onChangeFullNameEvent(
    ChangeFullNameEvent event,
    Emitter<StudyFormState> emit,
  ) {
    final currentUserDataOption = state.userData;
    currentUserDataOption.fold(() {}, (userData) {
      final updatedUserData = userData.copyWith(fullName: event.value);
      emit(state.copyWith(userData: some(updatedUserData)));
    });
  }

  Future<void> _onSaveChangesUserDataEvent(
    SaveChangesUserDataEvent event,
    Emitter<StudyFormState> emit,
  ) async {
    emit(state.copyWith(loading: true, userDataResult: none()));
    final storage = getIt<FlutterSecureStorage>();

    final userData = state.userData.fold(() => null, (r) => r);
    if (userData != null) {
      log(userData.toJson().toString());
      await storage.write(
        key: dotenv.env['USER_DATA']!,
        value: jsonEncode(userData.toJson()),
      );
      emit(
        state.copyWith(
          loading: false,
          saveUserDataResult: optionOf(right(unit)),
        ),
      );
    } else {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> _onLogOutEvent(
    LogOutEvent event,
    Emitter<StudyFormState> emit,
  ) async {
    emit(state.copyWith(loading: true, logOutResult: none()));
    final storage = getIt<FlutterSecureStorage>();

    await storage.delete(key: dotenv.env['USER_DATA']!);
    await deleteAllChatsUsecase(NoParams());
    emit(state.copyWith(loading: false, logOutResult: optionOf(right(unit))));
  }
}
