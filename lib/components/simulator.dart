import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Simulator extends StatefulWidget {
  final double padding;
  final double containerRadius;
  final Size size;
  final List<String> outsideValues;
  final List<String> insideValues;
  final List<Map<String, dynamic>> steps;
  final bool isModal;
  final List<Offset>? customOutsidePositions;
  final List<Offset>? customInsidePositions;
  final double? pointSize;

  const Simulator({
    super.key,
    required this.padding,
    required this.containerRadius,
    required this.size,
    required this.outsideValues,
    required this.insideValues,
    required this.steps,
    this.isModal = false,
    this.customOutsidePositions,
    this.customInsidePositions,
    this.pointSize,
  });

  @override
  State<Simulator> createState() => _SimulatorState();
}

class _SimulatorState extends State<Simulator> with SingleTickerProviderStateMixin {
  // Default positions for normal view
  final List<Offset> defaultOutsidePositions = [
    Offset(0.15, 0.167),  // OUT0
    Offset(0.145, 0.192),  // OUT1
    Offset(0.14 , 0.22),  // OUT2
    Offset(0.22, 0.195),  // OUT3
    Offset(0.215, 0.23),  // OUT4
    Offset(0.21, 0.26),  // OUT5
    Offset(0.4, 0.4 ),  // OUT6
  ];

  final List<Offset> defaultInsidePositions = [
    Offset(0.20, 0.12),  // IN0
    Offset(0.175, 0.167),  // IN1
    Offset(0.17, 0.199),  // IN2
    Offset(0.165, 0.23),  // IN3
    Offset(0.2, 0.175),  // IN4
    Offset(0.194, 0.205),  // IN5
    Offset(0.187, 0.24),  // IN6
  ];

  // Modal view positions
  final List<Offset> modalOutsidePositions = [
    Offset(0.45, 0.3),  // OUT0
    Offset(0.245, 0.292),  // OUT1
    Offset(0.24, 0.32),   // OUT2
    Offset(0.32, 0.295),  // OUT3
    Offset(0.315, 0.33),  // OUT4
    Offset(0.31, 0.36),   // OUT5
    Offset(0.5, 0.5),     // OUT6
  ];

  final List<Offset> modalInsidePositions = [
    Offset(0.30, 0.22),   // IN0
    Offset(0.275, 0.267), // IN1
    Offset(0.27, 0.299),  // IN2
    Offset(0.265, 0.33),  // IN3
    Offset(0.3, 0.275),   // IN4
    Offset(0.294, 0.305), // IN5
    Offset(0.287, 0.34),  // IN6
  ];

  List<Offset> get activeOutsidePositions => 
      widget.customOutsidePositions ?? 
      (widget.isModal ? modalOutsidePositions : defaultOutsidePositions);

  List<Offset> get activeInsidePositions => 
      widget.customInsidePositions ?? 
      (widget.isModal ? modalInsidePositions : defaultInsidePositions);

  double _getPointLeftPosition(double offsetX) {
    if (widget.isModal) {
      // Calculate relative to center of container
      final centerX = (widget.size.width - chairWidth) / 2;
      return centerX + (offsetX * chairWidth);
    }
    return offsetX * widget.size.width * 0.7;
  }

  double _getPointTopPosition(double offsetY) {
    if (widget.isModal) {
      // Calculate relative to vertical center
      final centerY = (widget.size.height - chairWidth) / 2;
      return centerY + (offsetY * chairWidth);
    }
    return offsetY * widget.size.height;
  }

  double get defaultPointSize => widget.isModal ? 25 : 15;
  double get activePointSize => widget.pointSize ?? defaultPointSize;
  
  double get chairWidth => widget.isModal ? widget.size.width * 0.6 : widget.size.width * 0.7;

  int? currentStepIndex;
  bool isSimulating = false;
  Timer? simulationTimer;
  double? stepProgress;

  late AnimationController _pulseController;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  double _getPulseScale(bool isActive) {
    if (!isActive || !isSimulating) return 1.0;
    final step = currentStepIndex != null ? widget.steps[currentStepIndex!] : null;
    final frequency = step?['frequency']?.toDouble() ?? 50.0;
    final intensity = step?['intensity']?.toDouble() ?? 50.0;
    
    // Scale pulse size based on intensity and make it more dramatic at lower frequencies
    final pulseRange = (intensity / 100) * (frequency < 50 ? 0.8 : 0.4);
    return 1.0 + (_pulseController.value * pulseRange);
  }

  bool isPointActive(String value) => value == 'P' || value == 'FP';

  void toggleSimulation() {
    setState(() {
      isSimulating = !isSimulating;
      if (isSimulating) {
        currentStepIndex = 0;
        startSimulation();
      } else {
        stopSimulation();
      }
    });
  }

  void startSimulation() {
    simulationTimer?.cancel();
    _pulseController.repeat(reverse: true);
    void runStep() {
      if (currentStepIndex! < widget.steps.length) {
        final step = widget.steps[currentStepIndex!];
        final duration = (step['duration'] * 1000).toInt(); // Convert to milliseconds
        
        setState(() => stepProgress = 0.0);
        
        final updateInterval = 100; // Update progress every 100ms
        var elapsed = 0;
        
        simulationTimer = Timer.periodic(Duration(milliseconds: updateInterval), (timer) {
          elapsed += updateInterval;
          setState(() {
            stepProgress = elapsed / duration;
            
            if (elapsed >= duration) {
              timer.cancel();
              currentStepIndex = currentStepIndex! + 1;
              stepProgress = null;
              
              if (currentStepIndex! < widget.steps.length) {
                runStep();
              } else {
                stopSimulation();
              }
            }
          });
        });
      }
    }

    if (isSimulating && currentStepIndex != null) {
      runStep();
    }
  }

  void stopSimulation() {
    simulationTimer?.cancel();
    simulationTimer = null;
    _pulseController.stop();
    setState(() {
      isSimulating = false;
      currentStepIndex = null;
      stepProgress = null;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    simulationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = currentStepIndex != null ? widget.steps[currentStepIndex!] : null;
    final outsideValues = currentStep?['outsideValues'] ?? widget.outsideValues;
    final insideValues = currentStep?['insideValues'] ?? widget.insideValues;
    final intensity = currentStep?['intensity']?.toDouble() ?? 50.0;
    final frequency = currentStep?['frequency']?.toDouble() ?? 50.0;

    // Update pulse speed based on frequency
    if (isSimulating) {
      // Exponential scaling for more dramatic speed changes
      final pulseSpeed = frequency >= 80 ? 150 :     // Ultra fast
                        frequency >= 60 ? 250 :    // Very fast
                        frequency >= 40 ? 500 :    // Medium
                        frequency >= 20 ? 900 :    // Slow
                        1200;                      // Very slow
      
      if (_pulseController.duration != Duration(milliseconds: pulseSpeed)) {
        _pulseController.duration = Duration(milliseconds: pulseSpeed);
        if (isSimulating) {
          _pulseController.repeat(reverse: true);
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Colors.blue.withOpacity(isSimulating ? (intensity / 800) : 0),
            Colors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('3D SIMULATOR',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.size.width * 0.014)),
                Row(
                  children: [
                    if (stepProgress != null)
                      Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        child: LinearProgressIndicator(
                          value: stepProgress,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        isSimulating ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: toggleSimulation,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient glow layer
                    if (isSimulating) 
                      Container(
                        width: widget.size.width,
                        height: widget.size.height,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.8,
                            colors: [
                              Colors.blue.withOpacity(intensity / 500),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    Center(
                      child: Image.asset(
                        'assets/chair1.png',
                        fit: BoxFit.cover,
                        width: chairWidth,
                      ),
                    ),
                    ...List.generate(
                      outsideValues.length,
                      (index) => Positioned(
                        left: _getPointLeftPosition(activeOutsidePositions[index].dx),
                        top: _getPointTopPosition(activeOutsidePositions[index].dy),
                        child: Transform.scale(
                          scale: _getPulseScale(isPointActive(outsideValues[index])),
                          child: Container(
                            width: activePointSize,
                            height: activePointSize,
                            decoration: BoxDecoration(
                              color: isPointActive(outsideValues[index])
                                  ? Colors.green.withOpacity(0.3 + (intensity / 200))
                                  : Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: isPointActive(outsideValues[index])
                                  ? [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(intensity / 200),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Similar changes for inside points but with purple color
                    ...List.generate(
                      insideValues.length,
                      (index) => Positioned(
                        left: _getPointLeftPosition(activeInsidePositions[index].dx),
                        top: _getPointTopPosition(activeInsidePositions[index].dy),
                        child: Transform.scale(
                          scale: _getPulseScale(isPointActive(insideValues[index])),
                          child: Container(
                            width: activePointSize,
                            height: activePointSize,
                            decoration: BoxDecoration(
                              color: isPointActive(insideValues[index])
                                  ? Colors.purple.withOpacity(0.3 + (intensity / 200))
                                  : Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: isPointActive(insideValues[index])
                                  ? [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(intensity / 200),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
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
      ),
    );
  }
}
