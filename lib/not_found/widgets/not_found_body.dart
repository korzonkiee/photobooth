import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/not_found/widgets/widgets.dart';

class NotFoundBody extends StatelessWidget {
  const NotFoundBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          SelectableText(
            l10n.notFoundPageHeading,
            key: const Key('notFoundPage_heading_text'),
            style: theme.textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SelectableText(
            l10n.notFoundPageSubheading,
            key: const Key('notFoundPage_subheading_text'),
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const NotFoundGoHomeButton(),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
