part of 'session_setup_cubit.dart';

class SessionSetupState extends Equatable {
  const SessionSetupState({
    required this.selectedPrompt,
    required this.promptList,
  });

  const SessionSetupState.initial()
      : this(
          selectedPrompt: '',
          promptList: prompts,
        );

  final String selectedPrompt;
  final List<String> promptList;

  @override
  List<Object?> get props => [
        selectedPrompt,
        promptList,
      ];

  SessionSetupState copyWith({
    String? selectedPrompt,
    List<String>? promptList,
  }) {
    return SessionSetupState(
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
      promptList: promptList ?? this.promptList,
    );
  }
}
