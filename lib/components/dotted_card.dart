import 'package:flutter/material.dart';

class DottedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;

  const DottedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.82),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2),
      ),
      child: Stack(
        children: [
          child,
          // Corner dots
          Positioned(left: 8, top: 8, child: _CornerDot(6, 1.2)),
          Positioned(right: 8, top: 8, child: _CornerDot(6, 1.2)),
          Positioned(left: 8, bottom: 8, child: _CornerDot(6, 1.2)),
          Positioned(right: 8, bottom: 8, child: _CornerDot(6, 1.2)),
        ],
      ),
    );
  }
}

class _CornerDot extends StatelessWidget {
  final double radius;
  final double borderWidth;
  const _CornerDot(this.radius, this.borderWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white.withOpacity(0.18), width: borderWidth),
        shape: BoxShape.circle,
      ),
    );
  }
}
