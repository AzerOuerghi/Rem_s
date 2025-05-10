import 'package:flutter/material.dart';
import 'simulator.dart';

class FullscreenSimulator extends StatelessWidget {
  final List<String> outsideValues;
  final List<String> insideValues;
  final List<Map<String, dynamic>> steps;

  const FullscreenSimulator({
    super.key,
    required this.outsideValues,
    required this.insideValues,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog.fullscreen(
      backgroundColor: Colors.black.withOpacity(0.95),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Simulator(
              padding: size.width * 0.012,
              containerRadius: size.width * 0.008,
              size: size,
              outsideValues: outsideValues,
              insideValues: insideValues,
              steps: steps,
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
