import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/session_setup/session_setup.dart';

class LandingSetupSessionButton extends StatelessWidget {
  const LandingSetupSessionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {
        trackEvent(
          category: 'button',
          action: 'click-setup-session',
          label: 'setup-session',
        );
        Navigator.of(context).push<void>(SessionSetupPage.route());
      },
      child: Text(l10n.landingPageSessionSetupButtonText),
    );
  }
}
