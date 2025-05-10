import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'components/pattern_editor.dart';
import 'components/simulator.dart';
import 'components/action_buttons.dart';
import 'components/pattern_summary.dart';
import 'components/dotted_card.dart';

class RemStudioScreen extends StatefulWidget {
  const RemStudioScreen({super.key});

  @override
  State<RemStudioScreen> createState() => _RemStudioScreenState();
}

class _RemStudioScreenState extends State<RemStudioScreen> {
  static const List<String> options = ['', 'X', 'P', 'FP'];
  final List<String> outsideValues = List.generate(7, (index) => '');
  final List<String> insideValues = List.generate(7, (index) => '');
  final List<Map<String, dynamic>> steps = [];

  int? editingIndex;

  void _addStep() {
    setState(() {
      if (editingIndex != null) {
        steps[editingIndex!] = {
          'outsideValues': List<String>.from(outsideValues),
          'insideValues': List<String>.from(insideValues),
          'intensity': _currentIntensity,
          'frequency': _currentFrequency,
          'duration': _currentDuration,
        };
        editingIndex = null;
      } else {
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
      outsideValues.setAll(0, List<String>.from(step['outsideValues']));
      insideValues.setAll(0, List<String>.from(step['insideValues']));
      _currentIntensity = step['intensity'];
      _currentFrequency = step['frequency'];
      _currentDuration = step['duration'];
      editingIndex = index;
    });
  }

  void _clearAllSteps() {
    setState(() {
      steps.clear();
      editingIndex = null;
      outsideValues.fillRange(0, outsideValues.length, '');
      insideValues.fillRange(0, insideValues.length, '');
      _currentIntensity = 50;
      _currentFrequency = 50;
      _currentDuration = 2.5;
    });
  }

  Future<void> _exportSteps() async {
    if (steps.isEmpty) {
      _showMessage('No steps to export.');
      return;
    }

    final jsonSteps = jsonEncode(steps);

    if (kIsWeb) {
      final bytes = utf8.encode(jsonSteps);
      final blob = html.Blob([bytes], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'massage_steps.json')
        ..click();
      html.Url.revokeObjectUrl(url);
      _showMessage('Steps exported (see your downloads).');
    } else {
      try {
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Massage Steps',
          fileName: 'massage_steps.json',
          type: FileType.custom,
          allowedExtensions: ['json'],
        );

        if (result != null) {
          final file = File(result);
          await file.writeAsString(jsonSteps);
          _showMessage('Steps exported successfully!');
        }
      } catch (e) {
        _showMessage('Failed to export steps: $e');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                            outsideValues: outsideValues,
                            insideValues: insideValues,
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
                          onExport: _exportSteps,
                          isEditing: editingIndex != null,
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
