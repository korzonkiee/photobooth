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
    this.session,
  });

  final SessionStatus status;
  final Session? session;

  @override
  List<Object?> get props => [session, status];

  SessionState copyWith({Session? session, SessionStatus? status}) {
    return SessionState(
      session: session ?? this.session,
      status: status ?? this.status,
    );
  }
}
