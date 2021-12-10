import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

part 'session_sharing_state.dart';

class SessionSharingCubit extends Cubit<SessionSharingState> {
  SessionSharingCubit({
    required SessionRepository sessionRepository,
    required String sessionId,
  })  : _sessionRepository = sessionRepository,
        super(SessionSharingState(
          sessionId: sessionId,
        ));

  final SessionRepository _sessionRepository;

  StreamSubscription<Session>? _sessionSubscription;

  void resetWithId(String sessionId) {
    emit(SessionSharingState(
      sessionId: sessionId,
    ));
  }

  Future<void> subscribe() async {
    await _sessionSubscription?.cancel();
    emit(state.copyWith(status: SessionSharingStatus.loading));
    try {
      _sessionSubscription = _sessionRepository
          .getSession(state.sessionId)
          .listen(_onSessionUpdated);
    } catch (e) {
      emit(state.copyWith(status: SessionSharingStatus.failure));
    }
  }

  Future<void> _onSessionUpdated(Session session) async {
    emit(state.copyWith(
      session: session,
    ));

    if (session.isInvalid) {
      emit(state.copyWith(status: SessionSharingStatus.failure));
      return;
    }

    final downloadablePhotoUrls =
        await _sessionRepository.getDownloadUrls(session.photoUrls);
    emit(state.copyWith(
      downloadablePhotoUrls: downloadablePhotoUrls,
      status: SessionSharingStatus.success,
    ));
  }

  @override
  Future<void> close() async {
    await _sessionSubscription?.cancel();
    await super.close();
  }
}
