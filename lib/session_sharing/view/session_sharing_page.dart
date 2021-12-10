import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class SessionSharingView extends StatelessWidget {
  const SessionSharingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final state = context.watch<SessionSharingCubit>().state;

    return BlocListener<SessionSharingCubit, SessionSharingState>(
      listener: (context, state) {
        if (state.status == SessionSharingStatus.failure) {
          context.go('/404');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 48),
              Text(
                'Sharing Page for Session: ${state.sessionId}',
                style: textTheme.headline2,
              ),
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
              else ...[
                const _PromptHeader(),
                if (state.downloadablePhotoUrls == null)
                  const _LoadingText(
                    child: Text('Downloading photos...'),
                  )
                else if (state.downloadablePhotoUrls!.isEmpty)
                  const Text('No photos have been uploaded yet.')
                else
                  Column(
                    children: [
                      for (final url in state.downloadablePhotoUrls!) ...[
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.network(url),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ],
                  ),
              ]
            ],
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

class _PromptHeader extends StatelessWidget {
  const _PromptHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final prompt = context
        .select((SessionSharingCubit cubit) => cubit.state.session!.prompt);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          prompt,
          style: textTheme.headline2,
        ),
      ),
    );
  }
}
