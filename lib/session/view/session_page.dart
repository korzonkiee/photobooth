import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/session/session.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:session_repository/session_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

const _videoConstraints = VideoConstraints(
  facingMode: FacingMode(
    type: CameraType.user,
    constrain: Constrain.ideal,
  ),
  width: VideoSize(ideal: 1920, maximum: 1920),
  height: VideoSize(ideal: 1080, maximum: 1080),
);

class SessionPage extends StatelessWidget {
  const SessionPage({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoboothBloc(),
      child: Navigator(
        onGenerateRoute: (_) => AppPageRoute(
          builder: (_) => SessionView(sessionId: sessionId),
        ),
      ),
    );
  }
}

class SessionView extends StatefulWidget {
  const SessionView({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  final String sessionId;

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _controller = CameraController(
    options: const CameraOptions(
      audio: AudioConstraints(enabled: false),
      video: _videoConstraints,
    ),
  );

  bool get _isCameraAvailable =>
      _controller.value.status == CameraStatus.available;

  Future<void> _play() async {
    if (!_isCameraAvailable) return;
    return _controller.play();
  }

  Future<void> _stop() async {
    if (!_isCameraAvailable) return;
    return _controller.stop();
  }

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCameraController() async {
    await _controller.initialize();
    await _play();
  }

  Future<void> _onSnapPressed({required double aspectRatio}) async {
    final picture = await _controller.takePicture();
    context
        .read<PhotoboothBloc>()
        .add(PhotoCaptured(aspectRatio: aspectRatio, image: picture));
    final stickersPage = SessionStickersPage.route(sessionId: widget.sessionId);
    await _stop();
    unawaited(Navigator.of(context).pushReplacement(stickersPage));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final aspectRatio = orientation == Orientation.portrait
        ? PhotoboothAspectRatio.portrait
        : PhotoboothAspectRatio.landscape;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _PhotoboothBackground(
            aspectRatio: aspectRatio,
            child: Camera(
              controller: _controller,
              placeholder: (_) => const SizedBox(),
              preview: (context, preview) => PhotoboothPreview(
                preview: preview,
                onSnapPressed: () => _onSnapPressed(aspectRatio: aspectRatio),
              ),
              error: (context, error) => PhotoboothError(error: error),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 64,
            child: _SessionPrompt(
              sessionId: widget.sessionId,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoboothBackground extends StatelessWidget {
  const _PhotoboothBackground({
    Key? key,
    required this.aspectRatio,
    required this.child,
  }) : super(key: key);

  final double aspectRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PhotoboothBackground(),
        Center(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              color: PhotoboothColors.black,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _SessionPrompt extends StatelessWidget {
  const _SessionPrompt({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionCubit(
        sessionId: sessionId,
        photosRepository: context.read<PhotosRepository>(),
        sessionRepository: context.read<SessionRepository>(),
      ),
      child: const _SessionPromptView(),
    );
  }
}

class _SessionPromptView extends StatelessWidget {
  const _SessionPromptView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Center(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                state.session?.prompt ?? '',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
