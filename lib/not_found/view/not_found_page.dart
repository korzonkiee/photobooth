import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/not_found/not_found.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: PhotoboothColors.white,
      body: NotFoundView(),
    );
  }
}

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppPageView(
      background: NotFoundBackground(),
      body: NotFoundBody(),
      footer: BlackFooter(),
    );
  }
}
