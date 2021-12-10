import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/view/landing_page.dart';

class NotFoundGoHomeButton extends StatelessWidget {
  const NotFoundGoHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {
        trackEvent(
          category: 'button',
          action: 'click-home-photobooth',
          label: 'home-photobooth',
        );
        Navigator.of(context).push<void>(LandingPage.route());
      },
      child: Text(l10n.notFoundPageGoHomeButtonText),
    );
  }
}
