import 'package:bloc/bloc.dart';
import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/features/studybot/domain/usecases/ask_gemini_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'studybot_event.dart';
part 'studybot_state.dart';

class StudybotBloc extends Bloc<StudybotEvent, StudybotState> {
  final AskGeminiUseCase askGeminiUseCase;
  StudybotBloc({required this.askGeminiUseCase})
    : super(StudybotState.initial()) {
    on<StudybotEvent>((event, emit) async {
      if (event is AskGeminiEvent) {
        await _onAskGeminiEvent(event, emit);
      }
    });
  }

  Future<void> _onAskGeminiEvent(
    AskGeminiEvent event,
    Emitter<StudybotState> emit,
  ) async {
    emit(state.copyWith(loading: true, message: ''));
    final result = await askGeminiUseCase(event.question);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loading: false,
            askGeminiResult: optionOf(left(failure)),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            loading: false,
            message: response,
            askGeminiResult: some(right(response)),
          ),
        );
      },
    );
  }
}
