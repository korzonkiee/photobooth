import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:io_photobooth/prompts/prompts.dart';
import 'package:session_repository/session_repository.dart';

part 'session_setup_state.dart';

class SessionSetupCubit extends Cubit<SessionSetupState> {
  SessionSetupCubit({
    required SessionRepository sessionRepository,
  })  : _sessionRepository = sessionRepository,
        super(
          const SessionSetupState.initial(),
        );

  final SessionRepository _sessionRepository;

  void changedQuery(String value) {
    final filtered = prompts
        .where((element) => element.toLowerCase().contains(value.toLowerCase()))
        .toList();

    emit(
      state.copyWith(
        promptList: [
          if (value.isNotEmpty) value,
          ...filtered,
        ],
      ),
    );
  }

  void selectPrompt(String value) {
    emit(
      state.copyWith(
        selectedPrompt: value,
      ),
    );
  }

  Future<void> createSession() async {
    try {
      emit(state.copyWith(status: SessionSetupStatus.loading));

      final session = await _sessionRepository.createSession(
        prompt: state.selectedPrompt,
      );
      final value = await session.first;

      emit(
        state.copyWith(
          createdSessionId: value.id,
          status: SessionSetupStatus.success,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: SessionSetupStatus.failure));
    }
  }
}
