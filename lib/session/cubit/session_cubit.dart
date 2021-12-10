import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:session_repository/session_repository.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required String sessionId,
    required SessionRepository sessionRepository,
    required PhotosRepository photosRepository,
  })  : _sessionId = sessionId,
        _sessionRepository = sessionRepository,
        _photosRepository = photosRepository,
        super(const SessionState(status: SessionStatus.initial)) {
    _sessionSub = _sessionRepository.getSession(sessionId).listen((session) {
      emit(state.copyWith(session: session));
    });
  }

  final String _sessionId;
  final SessionRepository _sessionRepository;
  final PhotosRepository _photosRepository;

  StreamSubscription<Session>? _sessionSub;

  Future<void> uploadImage({
    required CameraImage image,
    required double aspectRatio,
    required List<PhotoAsset> assets,
  }) async {
    try {
      emit(state.copyWith(status: SessionStatus.uploading));

      final photo = await _photosRepository.composite(
        width: image.width,
        height: image.height,
        data: image.data,
        layers: [
          ...assets.map(
            (l) => CompositeLayer(
              angle: l.angle,
              assetPath: 'assets/${l.asset.path}',
              constraints: Vector2D(l.constraint.width, l.constraint.height),
              position: Vector2D(l.position.dx, l.position.dy),
              size: Vector2D(l.size.width, l.size.height),
            ),
          )
        ],
        aspectRatio: aspectRatio,
      );

      await _sessionRepository.uploadSessionPhoto(
        sessionId: _sessionId,
        photo: photo,
      );

      emit(state.copyWith(status: SessionStatus.uploadingSuccess));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SessionStatus.uploadingError));
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _sessionSub?.cancel();
    return super.close();
  }
}
