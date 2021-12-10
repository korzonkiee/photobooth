import 'dart:ui' as ui;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:io_photobooth/session_sharing/session_sharing.dart';
import 'package:session_repository/session_repository.dart';

class SessionSharingPage extends StatelessWidget {
  const SessionSharingPage({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionSharingCubit(
        sessionRepository: context.read<SessionRepository>(),
        sessionId: sessionId,
      )..subscribe(),
      child: const SessionSharingView(),
    );
  }
}

class SessionSharingView extends StatefulWidget {
  const SessionSharingView({Key? key}) : super(key: key);

  @override
  State<SessionSharingView> createState() => _SessionSharingViewState();
}

class _SessionSharingViewState extends State<SessionSharingView> {
  late final GlobalKey _collageKey;

  @override
  void initState() {
    super.initState();

    _collageKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SessionSharingCubit>().state;
    final prompt = state.session?.prompt;

    Future<void> _saveCollage() async {
      final boundary = _collageKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage();
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();
        if (pngBytes != null) {
          final file = XFile.fromData(
            pngBytes,
            name: '$prompt.png',
            mimeType: 'image/png',
          );
          await file.saveTo('');
        }
      }
    }

    return BlocListener<SessionSharingCubit, SessionSharingState>(
      listener: (context, state) {
        if (state.status == SessionSharingStatus.failure) {
          context.go('/404');
        }
      },
      child: Scaffold(
        floatingActionButton: state.status == SessionSharingStatus.success
            ? FloatingActionButton(
                onPressed: () async {
                  await _saveCollage();
                },
                child: const Icon(Icons.download),
              )
            : null,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
          ),
          title: Text(prompt == null ? '...' : '"$prompt"'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                if (state.status == SessionSharingStatus.failure)
                  const Text(
                    'Error loading session. '
                    'Are you sure the ID is correct?',
                  )
                else if (state.session == null)
                  const _LoadingText(
                    child: Text('Loading session...'),
                  )
                else if (state.downloadablePhotoUrls == null)
                  const _LoadingText(
                    child: Text('Downloading photos...'),
                  )
                else if (state.downloadablePhotoUrls!.isEmpty)
                  const Text('No photos have been uploaded yet.')
                else
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: RepaintBoundary(
                      key: _collageKey,
                      child: Wrap(
                        children: [
                          for (final url in state.downloadablePhotoUrls!) ...[
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(8),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(url),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingText extends StatelessWidget {
  const _LoadingText({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
        const SizedBox(width: 8),
        const CupertinoActivityIndicator(),
      ],
    );
  }
}
