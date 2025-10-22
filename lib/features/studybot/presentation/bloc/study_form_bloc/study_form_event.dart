part of 'study_form_bloc.dart';

sealed class StudyFormEvent extends Equatable {
  const StudyFormEvent();

  @override
  List<Object> get props => [];
}

class LoadUserDataEvent extends StudyFormEvent {}

class ChangeFullNameEvent extends StudyFormEvent {
  final String value;
  const ChangeFullNameEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class SaveChangesUserDataEvent extends StudyFormEvent {}

class LogOutEvent extends StudyFormEvent {}