import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final double padding;
  final double containerRadius;
  final double buttonWidth;
  final double buttonHeight;
  final Size size;
  final VoidCallback onAddStep;
  final VoidCallback onClearAll;
  final VoidCallback onExport;
  final bool isEditing;

  const ActionButtons({
    super.key,
    required this.padding,
    required this.containerRadius,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.size,
    required this.onAddStep,
    required this.onClearAll,
    required this.onExport,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Text('ACTIONS', style: TextStyle(fontSize: size.width * 0.009)),
          SizedBox(height: size.height * 0.01),
          _buildButton(isEditing ? 'UPDATE STEP' : 'ADD STEP', onAddStep),
          _buildButton('CLEAR ALL', () => _showClearConfirmation(context)),
          _buildButton('EXPORT', onExport),
          _buildButton('SIMULATE', () {}),
        ],
      ),
    );
  }

  Future<void> _showClearConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Clear All Steps?', 
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to clear all steps? This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', 
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Clear All', 
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onClearAll();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.006),
      child: SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.zero,
          ),
          onPressed: onPressed,
          child: Text(text, style: TextStyle(fontSize: size.width * 0.009)),
        ),
      ),
    );
  }
}
