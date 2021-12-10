import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class NotFoundBackground extends StatelessWidget {
  const NotFoundBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('notFoundPage_background'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PhotoboothColors.gray,
            PhotoboothColors.white,
          ],
        ),
      ),
    );
  }
}
