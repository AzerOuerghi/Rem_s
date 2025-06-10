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

  double _currentIntensity = 50;  // 0-100%
  double _currentFrequency = 300; // 100-500ms
  double _currentDuration = 1.0;  // 0-5s with 0.1s steps
  int? editingIndex;

  // Add new state variables
  int? activeBladderIndex;
  String? selectedAdjustment;
  List<String> bladderStates = [];

  String? projectName;
  String? projectDescription;

  @override
  void initState() {
    super.initState();
    _initializeConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      projectName = args['projectName'] ?? projectName;
      projectDescription = args['projectDescription'] ?? projectDescription;
    }
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
        // If same adjustment is selected again, clear it
        if (selectedAdjustment == adjustment && bladderStates[activeBladderIndex!] == adjustment) {
          selectedAdjustment = '';
          bladderStates[activeBladderIndex!] = '';
          bladderValues[activeBladderIndex!] = '';
        } else {
          selectedAdjustment = adjustment;
          bladderStates[activeBladderIndex!] = adjustment;
          bladderValues[activeBladderIndex!] = adjustment;
        }
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
      _currentFrequency = 300;
      _currentDuration = 1.0;
    });
  }

  void _editStep(int index) {
    final step = steps[index];
    setState(() {
      bladderValues = List<String>.filled(config?.numBladders ?? 10, '');
      bladderStates = List<String>.filled(config?.numBladders ?? 10, '');
      
      final bladders = step['bladders'] as List;
      for (var bladder in bladders) {
        final position = bladder['position'] as int;
        final value = bladder['value'] as String;
        if (value.isNotEmpty) {
          bladderValues[position] = value;
          bladderStates[position] = value;
        }
      }
      
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
        'projectName': projectName ?? '',
        'projectDescription': projectDescription ?? '',
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
    final totalDurationMs = steps.fold<int>(0, (sum, step) => sum + (step['duration_ms'] as int));
    final totalDurationSec = totalDurationMs / 1000;
    final minutes = (totalDurationSec / 60).floor();
    final seconds = (totalDurationSec % 60).toStringAsFixed(1);
    final formattedDuration = minutes > 0 
        ? '$minutes min $seconds sec'
        : '$seconds seconds';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1D22),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Export Complete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExportMetricRow(
                      icon: Icons.drive_file_rename_outline,
                      label: 'Pattern Name',
                      value: projectName ?? 'Untitled',
                    ),
                    const Divider(height: 24, color: Colors.white10),
                    _buildExportMetricRow(
                      icon: Icons.format_list_numbered,
                      label: 'Total Steps',
                      value: '${steps.length}',
                    ),
                    const Divider(height: 24, color: Colors.white10),
                    _buildExportMetricRow(
                      icon: Icons.timer_outlined,
                      label: 'Total Duration',
                      value: formattedDuration,
                    ),
                    if (projectDescription?.isNotEmpty ?? false) ...[
                      const Divider(height: 24, color: Colors.white10),
                      _buildExportMetricRow(
                        icon: Icons.description_outlined,
                        label: 'Description',
                        value: projectDescription!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, 
                    size: 16, 
                    color: Colors.white.withOpacity(0.7)
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Files exported: JSON and Binary formats',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ));
  }

  Widget _buildExportMetricRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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
          _currentDuration = double.parse(value.toStringAsFixed(1));
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

  Widget _buildSectionHeader(String title, String tooltip, double scale) {
    return Row(
      children: [
        Tooltip(
          message: tooltip,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14 * scale,
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(12 * scale),
          child: Icon(
            Icons.info_outline,
            color: Colors.white54,
            size: 16 * scale,
          ),
        ),
        SizedBox(width: 8 * scale),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Acumin Pro Wide',
            fontSize: 15 * scale,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Color(0xA6FFFFFF),
                blurRadius: 10 * scale,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleWithInfo(String title, String tooltip, double scale) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Acumin Pro Wide',
            fontWeight: FontWeight.w700,
            fontSize: 15 * scale,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Color(0xA6FFFFFF),
                blurRadius: 10 * scale,
              ),
            ],
          ),
        ),
        SizedBox(width: 8 * scale),
        Tooltip(
          message: tooltip,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14 * scale,
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(12 * scale),
          child: Icon(
            Icons.info_outline,
            color: Colors.white54,
            size: 16 * scale,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Reference design size
    const double baseWidth = 1920;
    const double baseHeight = 1080;
    final double wScale = size.width / baseWidth;
    final double hScale = size.height / baseHeight;
    final double scale = wScale < hScale ? wScale : hScale;
    final numBladders = bladderValues.length;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double cScale = (constraints.maxWidth / baseWidth).clamp(0.5, 1.0);

          return Stack(
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
                left: constraints.maxWidth / 2 - (341 * cScale) / 2,
                top: 34 * cScale,
                child: SizedBox(
                  width: 341 * cScale,
                  height: 58 * cScale,
                  child: Text(
                    'REM STUDIO',
                    style: TextStyle(
                      fontFamily: 'Acumin Pro Wide',
                      fontSize: 48 * cScale,
                      fontWeight: FontWeight.w700,
                      height: 58 / 48,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          blurRadius: 16 * cScale,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Logo in top-left corner
              Positioned(
                left: 38 * cScale,
                top: 34 * cScale,
                child: Container(
                  width: 250 * cScale,
                  height: 90 * cScale,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 15 * cScale,
                        spreadRadius: 2 * cScale,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // 3D Simulator section
              Positioned(
                left: 38 * cScale,
                top: 132 * cScale,
                child: Container(
                  width: 1619 * cScale,
                  height: 598 * cScale,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18 * cScale),
                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 50 * cScale)],
                  ),
                  child: Stack(
                    children: [
                      // Chair image
                      Positioned(
                        left: 0,
                        top: -177 * cScale,
                        child: Image.asset(
                          'assets/chair.png',
                          width: 907 * cScale,
                          height: 1209 * cScale,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 3D SIMULATOR title
                      Positioned(
                        left: (38 + 40) * cScale,
                        top: 25 * cScale,
                        child: Text(
                          '3D SIMULATOR',
                          style: TextStyle(
                            fontFamily: 'Acumin Pro Wide',
                            fontWeight: FontWeight.w700,
                            fontSize: 16 * cScale,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Color(0xA6FFFFFF),
                                blurRadius: 8 * cScale,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Adjustment type selector
                      Positioned(
                        left: 841 * cScale,
                        top: 60 * cScale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              'SELECT ADJUSTMENT TYPE',
                              'X: Full Inflation (constant pressure)\nP: Pulse (rhythmic massage)\nFP: Full Pulse (stronger massage with complete cycles)',
                              cScale,
                            ),
                            SizedBox(height: 25 * cScale),
                            Container(
                              height: 44 * cScale,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildAdjustmentButton('X', cScale),
                                  SizedBox(width: 24 * cScale),
                                  _buildAdjustmentButton('P', cScale),
                                  SizedBox(width: 24 * cScale),
                                  _buildAdjustmentButton('FP', cScale),
                                ],
                              ),
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
                        return _buildBladderButton(i, cScale, left * cScale, top * cScale);
                      }),
                      // Sliders: INTENSITY, PULSE FREQUENCY, DURATION/STEP
                      Positioned(
                        left: 841 * cScale,
                        top: 207 * cScale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:  cScale),
                              child: _buildSectionHeader(
                                'INTENSITY',
                                'Controls the strength of the massage (0-100%). Higher values create stronger pressure.',
                                cScale,
                              ),
                            ),
                            SizedBox(height: 20 * cScale),
                            VerticalSlider(
                              value: _currentIntensity,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              onChanged: (v) => setState(() => _currentIntensity = v),
                              label: 'INTENSITY',
                              unit: '%',
                              valueLabel: _currentIntensity.round().toString(),
                              scale: cScale,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 1122 * cScale,
                        top: 207 * cScale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              'PULSE FREQUENCY',
                              'Sets the interval between pulses (100-500ms). Lower values create faster pulses.',
                              cScale,
                            ),
                            SizedBox(height: 20 * cScale),
                            VerticalSlider(
                              value: _currentFrequency,
                              min: 100,
                              max: 500,
                              divisions: 40,  // (500-100)/10 steps
                              onChanged: (v) => setState(() => _currentFrequency = v),
                              label: 'PULSE FREQUENCY',
                              unit: 'ms',
                              valueLabel: _currentFrequency.round().toString(),
                              scale: cScale,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 1450 * cScale,
                        top: 207 * cScale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              'DURATION/STEP',
                              'Sets how long each step runs (0-5s). Controls the timing of the massage sequence.',
                              cScale,
                            ),
                            SizedBox(height: 20 * cScale),
                            VerticalSlider(
                              value: _currentDuration,
                              min: 0,
                              max: 5,
                              divisions: 50, // 0.1s steps = 50 divisions
                              onChanged: (v) => setState(() => _currentDuration = double.parse(v.toStringAsFixed(1))),
                              label: 'DURATION / STEP',
                              unit: 's',
                              valueLabel: _currentDuration.toStringAsFixed(1),
                              scale: cScale,
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
                left: 1688 * cScale,
                top: 132 * cScale,
                child: Transform.scale(
                  scale: cScale,
                  alignment: Alignment.topLeft,
                  child: ActionButtons(
                    onAddStep: _addStep,
                    onClearAll: _clearAllSteps,
                    onExport: _exportSteps,
                    onSimulate: _showSimulator,
                    isEditing: editingIndex != null,
                  ),
                ),
              ),

              // Pattern Summary section
              Positioned(
                left: 38 * cScale,
                top: 746 * cScale,
                child: Container(
                  width: 1919 * cScale,
                  height: 349 * cScale,
                  child: DottedCard(
                    borderRadius: 18 * cScale,
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.012 * cScale),
                      child: PatternSummary(
                        size: Size(size.width * cScale, size.height * cScale),
                        steps: steps,
                        onDeleteStep: _deleteStep,
                        onEditStep: _editStep,
                        scale: cScale,
                        editingIndex: editingIndex,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBladderButton(int index, double scale, double left, double top) {
    final isActive = activeBladderIndex == index;
    final hasValue = bladderStates[index].isNotEmpty;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => _handleBladderTap(index),
        child: Container(
          width: 72 * scale,
          height: 42 * scale,
          decoration: BoxDecoration(
            color: hasValue ? const Color.fromRGBO(80,165,50,0.6) :
                   isActive ? Colors.white.withOpacity(0.2) :
                   Colors.white.withOpacity(0.1),
            border: Border.all(
              color: isActive ? Colors.white : const Color(0xFF85E264),
              width: isActive ? 2 * scale : 1 * scale,
            ),
            borderRadius: BorderRadius.circular(12 * scale),
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 6 * scale,
              )
            ] : null,
          ),
          child: Center(
            child: Text(
              hasValue ? bladderStates[index] : '${index + 1}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 16 * scale,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentButton(String label, double scale) {
    final isSelected = selectedAdjustment == label;
    
    return GestureDetector(
      onTap: () => _handleAdjustmentSelect(label),
      child: Container(
        width: 68 * scale,
        height: 44 * scale,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(activeBladderIndex != null ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(8 * scale),
          border: isSelected ? Border.all(color: Colors.white, width: 2 * scale) : null,
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 6.2 * scale,
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16 * scale,
              color: Colors.white.withOpacity(activeBladderIndex != null ? 1 : 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
