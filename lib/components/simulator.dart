import 'package:flutter/material.dart';

class Simulator extends StatefulWidget {
  final double padding;
  final double containerRadius;
  final Size size;
  final List<String> outsideValues;
  final List<String> insideValues;

  const Simulator({
    super.key,
    required this.padding,
    required this.containerRadius,
    required this.size,
    required this.outsideValues,
    required this.insideValues,
  });

  @override
  State<Simulator> createState() => _SimulatorState();
}

class _SimulatorState extends State<Simulator> {
  final List<Offset> outsidePositions = [
    Offset(0.15, 0.167),  // OUT0
    Offset(0.145, 0.192),  // OUT1
    Offset(0.14 , 0.22),  // OUT2
    Offset(0.22, 0.195),  // OUT3
    Offset(0.215, 0.23),  // OUT4
    Offset(0.21, 0.26),  // OUT5
    Offset(0.4, 0.4 ),  // OUT6
      // OUT7
  ];

  final List<Offset> insidePositions = [
     Offset(0.20, 0.12),  // OUT0
    Offset(0.175, 0.167),  // OUT1
    Offset(0.17, 0.199),  // OUT2
    Offset(0.165, 0.23),  // OUT3
    Offset(0.2, 0.175),  // OUT4
    Offset(0.194, 0.205),  // OUT5
    Offset(0.187, 0.24),  // IN7
  ];

  bool isPointActive(String value) => value == 'P' || value == 'FP';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Column(
        children: [
          Text('3D SIMULATOR',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.size.width * 0.014)),
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/chair1.png',
                    fit: BoxFit.cover,
                    width: widget.size.width * 0.7,
                  ),
                  ...List.generate(
                    widget.outsideValues.length,
                    (index) => Positioned(
                      left: outsidePositions[index].dx * widget.size.width * 0.7,
                      top: outsidePositions[index].dy * widget.size.height,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: isPointActive(widget.outsideValues[index])
                              ? Colors.green.withOpacity(0.5)
                              : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(
                    widget.insideValues.length,
                    (index) => Positioned(
                      left: insidePositions[index].dx * widget.size.width * 0.7,
                      top: insidePositions[index].dy * widget.size.height,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: isPointActive(widget.insideValues[index])
                              ? Colors.purple.withOpacity(0.5)
                              : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
