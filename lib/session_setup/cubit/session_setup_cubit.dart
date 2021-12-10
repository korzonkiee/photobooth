import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:io_photobooth/prompts/prompts.dart';

part 'session_setup_state.dart';

class SessionSetupCubit extends Cubit<SessionSetupState> {
  SessionSetupCubit() : super(const SessionSetupState.initial());

  void changedQuery(String value) {
    final filtered = prompts
        .where((element) => element.toLowerCase().contains(value.toLowerCase()))
        .toList();

    emit(state.copyWith(promptList: filtered));
  }

  void selectPrompt(String value) {
    emit(
      state.copyWith(
        selectedPrompt: value,
      ),
    );
  }

  void createSession() {
    // TODO
  }
}
