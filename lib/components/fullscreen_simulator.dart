import 'package:flutter/material.dart';
import 'dart:ui';
import 'simulator.dart';

class FullscreenSimulator extends StatelessWidget {
  final List<String> bladderValues;
  final List<Map<String, dynamic>> steps;

  const FullscreenSimulator({
    super.key,
    required this.bladderValues,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double baseWidth = 1181;
    const double baseHeight = 985;
    final double scale = (size.width / baseWidth).clamp(0.5, 1.0);

    final double dialogWidth = baseWidth * scale;
    final double dialogHeight = baseHeight * scale;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: dialogWidth,
            height: dialogHeight,
            margin: EdgeInsets.only(top: 74 * scale),
            decoration: BoxDecoration(
              color: const Color(0x33888888),
              borderRadius: BorderRadius.circular(18 * scale),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18 * scale),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50 * scale, sigmaY: 50 * scale),
                child: Simulator(
                  padding: 24 * scale,
                  containerRadius: 18 * scale,
                  size: Size(dialogWidth, dialogHeight),
                  bladderValues: bladderValues,
                  steps: steps,
                  isModal: true,
                  pointSize: 32 * scale,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
