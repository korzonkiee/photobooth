import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:io_photobooth/session_setup/session_setup.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:session_repository/session_repository.dart';

class SessionSetupPage extends StatelessWidget {
  const SessionSetupPage({Key? key}) : super(key: key);

  static Route route() {
    return AppPageRoute(builder: (_) => const SessionSetupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final sessionRepository = context.read<SessionRepository>();
        return SessionSetupCubit(sessionRepository: sessionRepository);
      },
      child: const SessionSetupView(),
    );
  }
}

class SessionSetupView extends StatelessWidget {
  const SessionSetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionSetupCubit, SessionSetupState>(
      listener: (context, state) {
        if (state.status == SessionSetupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Errors, sorry, try again'),
            ),
          );
        } else if (state.status == SessionSetupStatus.success) {
          final createdSessionId = state.createdSessionId;
          context.go('/session/$createdSessionId');
        }
      },
      builder: (context, state) {
        final continueButtonEnabled = state.selectedPrompt.isNotEmpty &&
            state.status != SessionSetupStatus.loading;
        return Scaffold(
          floatingActionButton: continueButtonEnabled
              ? FloatingActionButton(
                  onPressed: () {
                    context.read<SessionSetupCubit>().createSession();
                  },
                  child: const Icon(Icons.forward),
                )
              : null,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Choose a prompt bellow:',
                  style: Theme.of(context).textTheme.headline3,
                ),
                TextField(
                  onChanged: context.read<SessionSetupCubit>().changedQuery,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        for (final prompt in state.promptList)
                          InkWell(
                            onTap: () {
                              context
                                  .read<SessionSetupCubit>()
                                  .selectPrompt(prompt);
                            },
                            child: Container(
                              width: 240,
                              height: 120,
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                color: prompt == state.selectedPrompt
                                    ? Theme.of(context).primaryColor
                                    : null,
                                child: Center(
                                  child: Text(
                                    prompt,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
