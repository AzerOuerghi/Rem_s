import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onAddStep;
  final VoidCallback onClearAll;
  final VoidCallback onExport;
  final VoidCallback onSimulate;
  final bool isEditing;
  final double scale;

  const ActionButtons({
    super.key,
    required this.onAddStep,
    required this.onClearAll,
    required this.onExport,
    required this.onSimulate,
    this.isEditing = false,
    this.scale = 1.0,
  });

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Clear All Steps?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This action cannot be undone.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white10,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onClearAll();
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String get addStepButtonText => isEditing ? 'CONFIRM' : 'ADD STEP';

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: 189 * s,
      height: 598 * s,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18 * s),
        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 50 * s)],
      ),
      child: Column(
        children: [
          SizedBox(height: 25 * s),
          Text(
            'EDIT',
            style: TextStyle(
              fontFamily: 'Acumin Pro Wide',
              fontSize: 16 * s,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Color(0xA6FFFFFF),
                  blurRadius: 8 * s,
                ),
              ],
            ),
          ),
          SizedBox(height: 21 * s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 27 * s),
            child: Column(
              children: [
                _buildButton(addStepButtonText, onAddStep, background: Colors.white.withOpacity(0.1), scale: s),
                SizedBox(height: 21 * s),
                _buildButton('SIMULATE', onSimulate, background: const Color(0x1A00FFFF), scale: s),
                SizedBox(height: 21 * s),
                _buildButton('SAVE', () {}, background: const Color(0x1A00FF00), scale: s),
                SizedBox(height: 21 * s),
                _buildButton('CHECK STEP', () {}, background: const Color(0x1AFFFF00), scale: s),
                SizedBox(height: 21 * s),
                _buildButton('EXPORT', onExport, background: const Color(0x1A00FFFF), scale: s),
                SizedBox(height: 21 * s),
                _buildButton('CLEAR ALL', () => _showClearConfirmation(context), background: const Color(0x1AFF0000), scale: s),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, {Color? background, double scale = 1.0}) {
    return Container(
      width: 133 * scale,
      height: 44 * scale,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8 * scale),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 10 * scale),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16 * scale,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
