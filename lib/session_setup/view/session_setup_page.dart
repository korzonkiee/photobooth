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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Choose a prompt below:',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      onChanged: context.read<SessionSetupCubit>().changedQuery,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Filter or create a custom one here',
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: [
                          for (final prompt in state.promptList)
                            PromptCard(
                              prompt: prompt,
                              selected: prompt == state.selectedPrompt,
                              onTap: () {
                                context
                                    .read<SessionSetupCubit>()
                                    .selectPrompt(prompt);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PromptCard extends StatefulWidget {
  const PromptCard({
    Key? key,
    required this.prompt,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);

  final String prompt;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<PromptCard> {
  bool _hover = false;

  static const _normalSize = Size(240, 120);

  @override
  Widget build(BuildContext context) {
    final isBig = _hover || widget.selected;
    return InkWell(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _hover = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hover = false;
          });
        },
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          transform:
              isBig ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 250),
          child: Container(
            width: _normalSize.width,
            height: _normalSize.height,
            padding: const EdgeInsets.all(8),
            child: Card(
              color: widget.selected ? Theme.of(context).primaryColor : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    widget.prompt,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
