import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      ),
      child: const SessionSharingView(),
    );
  }
}

class SessionSharingView extends StatelessWidget {
  const SessionSharingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Share your session!'),
      ),
    );
  }
}
