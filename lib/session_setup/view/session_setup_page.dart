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
      create: (_) => SessionSetupCubit(),
      child: const SessionSetupView(),
    );
  }
}

class SessionSetupView extends StatelessWidget {
  const SessionSetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SessionSetupCubit>();
    final state = cubit.state;

    return Scaffold(
      floatingActionButton: state.selectedPrompt.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                //
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
              onChanged: cubit.changedQuery,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final prompt in state.promptList)
                      InkWell(
                        onTap: () {
                          cubit.selectPrompt(prompt);
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
  }
}
