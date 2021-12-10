part of 'session_sharing_cubit.dart';

enum SessionSharingStatus { initial, loading, success, failure }

class SessionSharingState extends Equatable {
  const SessionSharingState({
    this.status = SessionSharingStatus.initial,
    required this.sessionId,
    this.session,
    this.downloadablePhotoUrls,
  });

  final SessionSharingStatus status;
  final String sessionId;
  final Session? session;
  final List<String>? downloadablePhotoUrls;

  @override
  List<Object?> get props => [
        status,
        sessionId,
        session,
        downloadablePhotoUrls,
      ];

  SessionSharingState copyWith({
    SessionSharingStatus? status,
    String? sessionId,
    Session? session,
    List<String>? downloadablePhotoUrls,
  }) {
    return SessionSharingState(
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      session: session ?? this.session,
      downloadablePhotoUrls:
          downloadablePhotoUrls ?? this.downloadablePhotoUrls,
    );
  }
}
