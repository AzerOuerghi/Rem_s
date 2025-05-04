import 'package:flutter/material.dart';
import 'components/pattern_editor.dart';
import 'components/simulator.dart';
import 'components/action_buttons.dart';
import 'components/pattern_summary.dart';
import 'components/dotted_card.dart';
import 'welcome_page.dart';

void main() => runApp(const RemStudioApp());

class RemStudioApp extends StatelessWidget {
  const RemStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REM Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/customise': (context) => const RemStudioScreen(),
      },
    );
  }
}

class RemStudioScreen extends StatefulWidget {
  const RemStudioScreen({super.key});

  @override
  State<RemStudioScreen> createState() => _RemStudioScreenState();
}

class _RemStudioScreenState extends State<RemStudioScreen> {
  static const List<String> options = ['', 'X', 'P', 'FP']; // Add empty option
  final List<String> outsideValues = List.generate(7, (index) => ''); // Empty by default
  final List<String> insideValues = List.generate(7, (index) => ''); // Empty by default
  final List<Map<String, dynamic>> steps = [];  // Store all steps

  int? editingIndex; // Add editing state

  void _addStep() {
    setState(() {
      if (editingIndex != null) {
        // Update existing step
        steps[editingIndex!] = {
          'outsideValues': List<String>.from(outsideValues),
          'insideValues': List<String>.from(insideValues),
          'intensity': _currentIntensity,
          'frequency': _currentFrequency,
          'duration': _currentDuration,
        };
        editingIndex = null; // Exit edit mode
      } else {
        // Add new step
        steps.add({
          'outsideValues': List<String>.from(outsideValues),
          'insideValues': List<String>.from(insideValues),
          'intensity': _currentIntensity,
          'frequency': _currentFrequency,
          'duration': _currentDuration,
        });
      }
    });
  }

  void _deleteStep(int index) {
    setState(() {
      steps.removeAt(index);
    });
  }

  void _editStep(int index) {
    final step = steps[index];
    setState(() {
      // Load values into editor
      outsideValues.setAll(0, List<String>.from(step['outsideValues']));
      insideValues.setAll(0, List<String>.from(step['insideValues']));
      _currentIntensity = step['intensity'];
      _currentFrequency = step['frequency'];
      _currentDuration = step['duration'];
      editingIndex = index; // Set editing mode
    });
  }

  void _clearAllSteps() {
    setState(() {
      steps.clear();
      editingIndex = null;
      // Reset current values
      outsideValues.fillRange(0, outsideValues.length, '');
      insideValues.fillRange(0, insideValues.length, '');
      _currentIntensity = 50;
      _currentFrequency = 50;
      _currentDuration = 2.5;
    });
  }

  // Current values from sliders
  double _currentIntensity = 50;
  double _currentFrequency = 50;
  double _currentDuration = 2.5;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.012;
    final containerRadius = size.width * 0.008;
    final nodeWidth = size.width * 0.075;
    final nodeHeight = size.height * 0.038;
    final sliderHeight = size.height * 0.20;
    final buttonWidth = size.width * 0.11;
    final buttonHeight = size.height * 0.038;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.012),
                const Text(
                  'REM STUDIO',
                  
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: size.height * 0.016),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: PatternEditor(
                          options: options,
                          outsideValues: outsideValues,
                          insideValues: insideValues,
                          onOutsideChanged: (i, v) => setState(() => outsideValues[i] = v),
                          onInsideChanged: (i, v) => setState(() => insideValues[i] = v),
                          padding: padding,
                          containerRadius: containerRadius,
                          nodeWidth: nodeWidth,
                          nodeHeight: nodeHeight,
                          sliderHeight: sliderHeight,
                          size: size,
                          intensity: _currentIntensity,
                          pulseFrequency: _currentFrequency,
                          duration: _currentDuration,
                          onIntensityChanged: (v) => _updateSliderValues('intensity', v),
                          onFrequencyChanged: (v) => _updateSliderValues('frequency', v),
                          onDurationChanged: (v) => _updateSliderValues('duration', v),
                        ),
                      ),
                      SizedBox(width: size.width * 0.015),
                      Expanded(
                        child: DottedCard(
                          borderRadius: containerRadius * 2,
                          child: Simulator(
                            padding: padding,
                            containerRadius: containerRadius,
                            size: size,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.015),
                      DottedCard(
                        width: buttonWidth + padding * 2,
                        borderRadius: containerRadius * 2,
                        child: ActionButtons(
                          padding: padding,
                          containerRadius: containerRadius,
                          buttonWidth: buttonWidth,
                          buttonHeight: buttonHeight,
                          size: size,
                          onAddStep: _addStep,
                          onClearAll: _clearAllSteps,
                          isEditing: editingIndex != null, // Pass editing state
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.012),
                DottedCard(
                  borderRadius: containerRadius * 2,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: PatternSummary(
                      size: size,
                      steps: steps,
                      onDeleteStep: _deleteStep,
                      onEditStep: _editStep,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.012),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
