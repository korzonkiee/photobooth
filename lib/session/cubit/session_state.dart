part of 'session_cubit.dart';

enum SessionStatus {
  initial,
  uploading,
  uploadingSuccess,
  uploadingError,
}

class SessionState extends Equatable {
  const SessionState({
    required this.status,
  });

  final SessionStatus status;

  @override
  List<Object> get props => [status];

  SessionState copyWith({SessionStatus? status}) {
    return SessionState(
      status: status ?? this.status,
    );
  }
}
