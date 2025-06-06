import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Simulator extends StatefulWidget {
  final double padding;
  final double containerRadius;
  final Size size;
  final List<String> bladderValues;  // Single list of bladder values
  final List<Map<String, dynamic>> steps;
  final bool isModal;
  final List<Offset>? customPositions;  // Single list of positions for bladders
  final double? pointSize;

  const Simulator({
    super.key,
    required this.padding,
    required this.containerRadius,
    required this.size,
    required this.bladderValues,
    required this.steps,
    this.isModal = false,
    this.customPositions,
    this.pointSize,
  });

  @override
  State<Simulator> createState() => _SimulatorState();
}

class _SimulatorState extends State<Simulator> with SingleTickerProviderStateMixin {
  // Update positions calculation for dynamic number of bladders
  List<Offset> generateDefaultPositions(int count) {
    // Create a grid layout for dynamic number of bladders
    const double startX = 0.2;
    const double startY = 0.2;
    const double spacing = 0.08;
    const int itemsPerRow = 4;
    
    return List.generate(count, (index) {
      final row = index ~/ itemsPerRow;
      final col = index % itemsPerRow;
      return Offset(
        startX + (col * spacing),
        startY + (row * spacing),
      );
    });
  }

  List<Offset> get activePositions {
    if (widget.customPositions != null) return widget.customPositions!;
    return generateDefaultPositions(widget.bladderValues.length);
  }

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

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  bool isPointActive(String value) {
    return value == 'P' || value == 'FP';
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
        final duration = step['duration_ms'] as int; // Now using duration_ms
        
        setState(() => stepProgress = 0.0);
        
        final updateInterval = 100; // Update progress every 100ms
        var elapsed = 0;
        
        simulationTimer = Timer.periodic(Duration(milliseconds: updateInterval), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }

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
    final currentBladders = currentStep?['bladders'] as List?;
    final List<String> currentValues = currentBladders?.map((b) => b['value'] as String).toList() 
                                     ?? widget.bladderValues;
    final intensity = currentStep?['intensity']?.toDouble() ?? 50.0;
    final frequency = currentStep?['frequency']?.toDouble() ?? 50.0;

    // Update pulse speed based on frequency
    if (isSimulating) {
      final pulseSpeed = frequency >= 80 ? 150 :
                        frequency >= 60 ? 250 :
                        frequency >= 40 ? 500 :
                        frequency >= 20 ? 900 :
                        1200;
      
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
                        'assets/chair.png',
                        fit: BoxFit.cover,
                        width: chairWidth,
                      ),
                    ),
                    // Bladder indicators
                    ...List.generate(
                      currentValues.length,
                      (index) {
                        if (index >= activePositions.length) return const SizedBox.shrink();
                        return Positioned(
                          left: _getPointLeftPosition(activePositions[index].dx),
                          top: _getPointTopPosition(activePositions[index].dy),
                          child: Transform.scale(
                            scale: _getPulseScale(isPointActive(currentValues[index])),
                            child: Container(
                              width: 24,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isPointActive(currentValues[index])
                                    ? const Color.fromRGBO(51, 204, 0, 0.5)
                                    : Colors.white.withOpacity(0.1),
                                border: Border.all(
                                  color: const Color(0xFF75FF46),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        );
                      },
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
