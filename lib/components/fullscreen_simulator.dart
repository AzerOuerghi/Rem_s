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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main container with blur
          Container(
            width: 1181,
            height: 985,
            margin: const EdgeInsets.only(top: 74), // +37px from center
            decoration: BoxDecoration(
              color: const Color(0x33888888),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Chair image
                    Positioned(
                      left: (1181 - 778) / 2, // Center horizontally
                      top: (985 - 1037.33) / 2, // Center vertically
                      child: Image.asset(
                        'assets/chair2.png',
                        width: 778,
                        height: 1037.33,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Simulator overlay
                    Positioned(
                      left: 967,
                      top: 397,
                      child: SizedBox(
                        width: 211.91,
                        height: 371.59,
                        child: CustomPaint(
                          painter: SimulatorOverlayPainter(
                            bladderValues: bladderValues,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimulatorOverlayPainter extends CustomPainter {
  final List<String> bladderValues;

  SimulatorOverlayPainter({required this.bladderValues});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x99509F32) // rgba(80, 165, 50, 0.6)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF85E264)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.87;

    // Add your bladder position paths here using the percentage positions from design
    // Example for first bladder (38.76%, 0.12%):
    final path = Path()
      ..moveTo(size.width * 0.3876, size.height * 0.0012)
      // Add more points to complete the shape
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
