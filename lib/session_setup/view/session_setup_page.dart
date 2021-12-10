import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/session_setup/session_setup.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SessionSetupPage extends StatelessWidget {
  const SessionSetupPage({Key? key}) : super(key: key);

  static Route route() {
    return AppPageRoute(builder: (_) => const SessionSetupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionSetupBloc(),
      child: const SessionSetupView(),
    );
  }
}

class SessionSetupView extends StatelessWidget {
  const SessionSetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Start your session!'),
      ),
    );
  }
}
