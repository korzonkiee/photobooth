import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:session_repository/session_repository.dart';

class LandingBody extends StatelessWidget {
  const LandingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const Center(
            child: _SessionDebugCard(),
          ),
          const SizedBox(height: 48),
          SelectableText(
            l10n.landingPageHeading,
            key: const Key('landingPage_heading_text'),
            style: theme.textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SelectableText(
            l10n.landingPageSubheading,
            key: const Key('landingPage_subheading_text'),
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const LandingTakePhotoButton(),
          const SizedBox(height: 24),
          const LandingSetupSessionButton(),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Image.asset(
              'assets/backgrounds/landing_background.png',
              height: size.width <= PhotoboothBreakpoints.small
                  ? size.height * 0.4
                  : size.height * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionDebugCard extends StatelessWidget {
  const _SessionDebugCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = context.read<SessionRepository>();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('DEBUG SESSION /sessions/example'),
            const SizedBox(height: 8),
            StreamBuilder<Session>(
              stream: repo.getSession('example'),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Error\n${snapshot.error}\n${snapshot.stackTrace}',
                  );
                } else if (!snapshot.hasData) {
                  return const CupertinoActivityIndicator();
                }

                final session = snapshot.data!;

                return Column(
                  children: [
                    Text('$session'),
                    const SizedBox(height: 8),
                    Text('Contains ${session.photoUrls.length} photos.'),
                    const SizedBox(height: 4),
                    FutureBuilder<List<String>>(
                      future: repo.getDownloadUrls(session.photoUrls),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'Error\n${snapshot.error}\n${snapshot.stackTrace}',
                          );
                        } else if (!snapshot.hasData) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CupertinoActivityIndicator(),
                              SizedBox(width: 4),
                              Text('Downloading URLs...'),
                            ],
                          );
                        }

                        final urls = snapshot.data!;

                        return Column(
                          children: [
                            for (final url in urls)
                              Image.network(
                                url,
                                width: 300,
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
