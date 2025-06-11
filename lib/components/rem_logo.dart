import 'package:flutter/material.dart';

class RemLogo extends StatelessWidget {
  final double scale;

  const RemLogo({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 38 * scale,
      top: 34 * scale,
      child: Container(
        width: 250 * scale,
        height: 90 * scale,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 15 * scale,
              spreadRadius: 2 * scale,
            ),
          ],
        ),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
