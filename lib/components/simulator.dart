import 'package:flutter/material.dart';

class Simulator extends StatelessWidget {
  final double padding;
  final double containerRadius;
  final Size size;

  const Simulator({
    super.key,
    required this.padding,
    required this.containerRadius,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Text('3D SIMULATOR',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.014)),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/chair.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
