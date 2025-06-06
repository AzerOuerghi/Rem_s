import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/fullscreen_simulator.dart';
import 'utils/file_export.dart';
import 'components/pattern_editor.dart';
import 'components/simulator.dart';
import 'components/action_buttons.dart';
import 'components/pattern_summary.dart';
import 'components/dotted_card.dart';
import 'services/config_service.dart';
import 'components/vertical_slider.dart';

class RemStudioScreen extends StatefulWidget {
  const RemStudioScreen({super.key});

  @override
  State<RemStudioScreen> createState() => _RemStudioScreenState();
}

class _RemStudioScreenState extends State<RemStudioScreen> {
  static const List<String> options = ['', 'X', 'P', 'FP'];
  List<String> bladderValues = [];  // Single list for all bladders
  final List<Map<String, dynamic>> steps = [];
  ConfigService? config;
  bool isLoading = true;

  double _currentIntensity = 50;
  double _currentFrequency = 50;
  double _currentDuration = 2.5;
  int? editingIndex;

  // Add new state variables
  int? activeBladderIndex;
  String? selectedAdjustment;
  List<String> bladderStates = [];

  @override
  void initState() {
    super.initState();
    _initializeConfig();
  }

  Future<void> _initializeConfig() async {
    config = await ConfigService.getInstance();
    setState(() {
      // Initialize with empty values for each bladder
      bladderValues = List.filled(config!.numBladders, '');
      bladderStates = List.filled(config!.numBladders, '');
      isLoading = false;
    });
  }

  void _handleBladderTap(int index) {
    setState(() {
      if (activeBladderIndex == index) {
        // Deactivate if tapping the same bladder
        activeBladderIndex = null;
        selectedAdjustment = null;
      } else {
        // Activate new bladder
        activeBladderIndex = index;
      }
    });
  }

  void _handleAdjustmentSelect(String adjustment) {
    if (activeBladderIndex != null) {
      setState(() {
        selectedAdjustment = adjustment;
        bladderStates[activeBladderIndex!] = adjustment;
        bladderValues[activeBladderIndex!] = adjustment;
        // Removed auto-progression to next bladder
      });
    }
  }

  void _addStep() {
    if (bladderValues.any((value) => value.isNotEmpty)) {
      setState(() {
        if (editingIndex != null) {
          steps[editingIndex!] = _createStepData(editingIndex! + 1);
          editingIndex = null;
        } else {
          steps.add(_createStepData(steps.length + 1));
        }
        // Reset all states
        activeBladderIndex = null;
        selectedAdjustment = null;
        bladderValues = List.filled(config?.numBladders ?? 10, '');
        bladderStates = List.filled(config?.numBladders ?? 10, '');
      });
    }
  }

  void _clearAllSteps() {
    setState(() {
      steps.clear();
      editingIndex = null;
      bladderValues = List.filled(config?.numBladders ?? 10, '');
      _currentIntensity = 50;
      _currentFrequency = 50;
      _currentDuration = 2.5;
    });
  }

  void _editStep(int index) {
    final step = steps[index];
    setState(() {
      bladderValues = List<String>.from(step['bladders'].map((b) => b['value']));
      _currentIntensity = step['intensity'];
      _currentFrequency = step['frequency'];
      _currentDuration = step['duration_ms'] / 1000;
      editingIndex = index;
    });
  }

  void _deleteStep(int index) {
    setState(() {
      steps.removeAt(index);
      if (editingIndex != null && index <= editingIndex!) {
        editingIndex = editingIndex! - 1;
        if (editingIndex! < 0) editingIndex = null;
      }
    });
  }

  Future<void> _exportSteps() async {
    if (steps.isEmpty) {
      _showMessage('No steps to export.');
      return;
    }

    try {
      final formattedSteps = steps.map((step) {
        return {
          'step_id': step['step_id'] as int,
          'num_actions': step['num_actions'] as int,
          'bladders': step['bladders'],
          'intensity': (step['intensity'] as double).round(),
          'frequency': (step['frequency'] as double).round(),
          'duration_ms': step['duration_ms'],
        };
      }).toList();

      final exportData = {
        'totalSteps': steps.length,
        'steps': formattedSteps,
      };
      
      final encoder = JsonEncoder.withIndent('  ');
      final jsonSteps = encoder.convert(exportData);
      await FileExportUtil.instance.exportJson(jsonSteps, 'massage_steps.json');
      _showExportDialog();
    } catch (e) {
      print('Export error: $e');
      _showMessage('Failed to export steps: $e');
    }
  }

  Map<String, dynamic> _createStepData(int stepId) {
    final arrangements = bladderValues.asMap().entries.map((entry) => {
      'bladder_id': entry.key + 1,
      'value': entry.value,
      'position': entry.key,
      'arrangement_order': entry.key + 1,
    }).toList();

    return {
      'step_id': stepId,
      'num_actions': bladderValues.where((v) => v == 'P' || v == 'FP'|| v == 'X').length,
      'bladders': arrangements,
      'intensity': _currentIntensity.round(),
      'frequency': _currentFrequency.round(),
      'duration_ms': (_currentDuration * 1000).round(),
    };
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1D22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Export Successful',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${steps.length} steps have been exported',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _updateSliderValues(String type, double value) {
    setState(() {
      switch (type) {
        case 'intensity':
          _currentIntensity = value;
          break;
        case 'frequency':
          _currentFrequency = value;
          break;
        case 'duration':
          _currentDuration = value;
          break;
      }
    });
  }

  void _showSimulator() {
    showDialog(
      context: context,
      builder: (context) => FullscreenSimulator(
        bladderValues: bladderValues,
        steps: steps,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final numBladders = bladderValues.length;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          // Title
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 170.5 + 25.5,
            top: 34,
            child: SizedBox(
              width: 341,
              height: 58,
              child: Text(
                'REM STUDIO',
                style: TextStyle(
                  fontFamily: 'Acumin Pro Wide',
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 58/48,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3D Simulator section
          Positioned(
            left: 38,
            top: 132,
            child: Container(
              width: 1619, // Reduced from 1719
              height: 598,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 50)],
              ),
              child: Stack(
                children: [
                  // Chair image
                  Positioned(
                    left: 0,
                    top: -177,
                    child: Image.asset(
                      'assets/chair.png',
                      width: 907,
                      height: 1209,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 3D SIMULATOR title
                  Positioned(
                    left: 38 + 40,
                    top: 25,
                    child: const Text(
                      '3D SIMULATOR',
                      style: TextStyle(
                        fontFamily: 'Acumin Pro Wide',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color(0xA6FFFFFF),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Adjustment type selector
                  Positioned(
                    left: 841,
                    top: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SELECT ADJUSTMENT TYPE',
                          style: TextStyle(
                            fontFamily: 'Acumin Pro Wide',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Color(0xA6FFFFFF),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            _buildAdjustmentButton('X'),
                            const SizedBox(width: 24),
                            _buildAdjustmentButton('P'),
                            const SizedBox(width: 24),
                            _buildAdjustmentButton('FP'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Dynamic bladder buttons (5x2 grid)
                  ...List.generate(numBladders, (i) {
                    final col = i < 5 ? 0 : 1;
                    final row = i % 5;
                    final left = 385 + col * 113;
                    final top = 200 + row * 62;
                    return _buildBladderButton(i);
                  }),
                  // Highlight selected bladder (optional)
                  // Sliders: INTENSITY, PULSE FREQUENCY, DURATION/STEP
                  Positioned(
                    left: 841,
                    top: 207,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 13.75),
                          child: Text(
                            'INTENSITY',
                            style: TextStyle(
                              fontFamily: 'Acumin Pro Wide',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color(0xA6FFFFFF),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        VerticalSlider(
                          value: _currentIntensity,
                          min: 0,
                          max: 100,
                          divisions: 20,
                          onChanged: (v) => setState(() => _currentIntensity = v),
                          label: 'INTENSITY',
                          unit: '%',
                          valueLabel: _currentIntensity.round().toString(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 1138,
                    top: 207,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PULSE FREQUENCY',
                          style: TextStyle(
                            fontFamily: 'Acumin Pro Wide',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Color(0xA6FFFFFF),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        VerticalSlider(
                          value: _currentFrequency,
                          min: 0,
                          max: 100,
                          divisions: 20,
                          onChanged: (v) => setState(() => _currentFrequency = v),
                          label: 'PULSE FREQUENCY',
                          unit: 'Hz',
                          valueLabel: _currentFrequency.round().toString(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 1483,
                    top: 207,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DURATION/STEP',
                          style: TextStyle(
                            fontFamily: 'Acumin Pro Wide',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Color(0xA6FFFFFF),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        VerticalSlider(
                          value: _currentDuration,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          onChanged: (v) => setState(() => _currentDuration = v),
                          label: 'DURATION / STEP',
                          unit: 'ms',
                          valueLabel: _currentDuration.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons section
          Positioned(
            left: 1688, // Adjusted from 1768 to add more space
            top: 132,
            child: ActionButtons(
              onAddStep: _addStep,
              onClearAll: _clearAllSteps,
              onExport: _exportSteps,
              onSimulate: _showSimulator,
              isEditing: editingIndex != null,
            ),
          ),

          // Pattern Summary section
          Positioned(
            left: 38,
            top: 746,
            child: Container(
              width: 1919,
              height: 349,
              child: DottedCard(
                borderRadius: 18,
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.012),
                  child: PatternSummary(
                    size: size,
                    steps: steps,
                    onDeleteStep: _deleteStep,
                    onEditStep: _editStep,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBladderButton(int index) {
    final isActive = activeBladderIndex == index;
    final hasValue = bladderStates[index].isNotEmpty;
    
    return Positioned(
      left: 385 + (index >= 5 ? 113 : 0).toDouble(),
      top: (200 + (index % 5) * 62).toDouble(),
      child: GestureDetector(
        onTap: () => _handleBladderTap(index),
        child: Container(
          width: 72,
          height: 42,
          decoration: BoxDecoration(
            color: hasValue ? const Color.fromRGBO(80, 165, 50, 0.6) :
                   isActive ? Colors.white.withOpacity(0.2) :
                   Colors.white.withOpacity(0.1),
            border: Border.all(
              color: isActive ? Colors.white : const Color(0xFF85E264),
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 6,
              )
            ] : null,
          ),
          child: Center(
            child: Text(
              hasValue ? bladderStates[index] : '${index + 1}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentButton(String label) {
    final isSelected = selectedAdjustment == label;
    return GestureDetector(
      onTap: () => _handleAdjustmentSelect(label),
      child: Container(
        width: 68,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(activeBladderIndex != null ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 6.2,
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.white.withOpacity(activeBladderIndex != null ? 1 : 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
