import 'package:flutter/material.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});
  static const String routeName = '/order';
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.black,
            Colors.cyanAccent,
          ],
        ),
      ),
      child: child,
    );
  }
}
