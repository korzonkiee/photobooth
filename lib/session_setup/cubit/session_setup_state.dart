part of 'session_setup_cubit.dart';

enum SessionSetupStatus {
  initial,
  loading,
  success,
  failure,
}

class SessionSetupState extends Equatable {
  const SessionSetupState({
    required this.createdSessionId,
    required this.selectedPrompt,
    required this.promptList,
    required this.status,
  });

  const SessionSetupState.initial()
      : this(
          createdSessionId: '',
          selectedPrompt: '',
          promptList: prompts,
          status: SessionSetupStatus.initial,
        );

  final SessionSetupStatus status;
  final String selectedPrompt;
  final List<String> promptList;
  final String createdSessionId;

  @override
  List<Object?> get props => [
        selectedPrompt,
        promptList,
        status,
        createdSessionId,
      ];

  SessionSetupState copyWith({
    String? createdSessionId,
    String? selectedPrompt,
    List<String>? promptList,
    SessionSetupStatus? status,
  }) {
    return SessionSetupState(
      createdSessionId: createdSessionId ?? this.createdSessionId,
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
      promptList: promptList ?? this.promptList,
      status: status ?? this.status,
    );
  }
}
