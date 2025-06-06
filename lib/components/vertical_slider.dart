import 'package:flutter/material.dart';

class VerticalSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String label;
  final String unit;
  final String valueLabel;

  const VerticalSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.label,
    required this.unit,
    required this.valueLabel,
  });

  @override
  State<VerticalSlider> createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  double? dragStartY;
  double? dragStartValue;
  static const double _sliderHeight = 180.18;

  void _handleDragStart(DragStartDetails details) {
    dragStartY = details.localPosition.dy;
    dragStartValue = widget.value;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (dragStartY != null && dragStartValue != null) {
      final dragDelta = details.localPosition.dy - dragStartY!;
      final valueRange = widget.max - widget.min;
      final valueDelta = -(dragDelta / _sliderHeight) * valueRange;
      final newValue = (dragStartValue! + valueDelta).clamp(widget.min, widget.max);
      widget.onChanged(newValue);
    }
  }

  Widget _buildTickMark(bool active) {
    return Container(
      width: 11.34,
      height: 2.52,
      decoration: BoxDecoration(
        gradient: active ? const LinearGradient(
          begin: Alignment(-0.5, -1),
          end: Alignment(1, 1),
          colors: [Colors.white, Color(0xFFCFFCFF)],
        ) : null,
        color: active ? null : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104.25,
      height: 230,
      child: Stack(
        children: [
          // Value display
          Positioned(
            left: 0.5,
            top: 0,
            child: Container(
              width: 64,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 17.5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.valueLabel,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
            ),
          ),

          // Main slider track and interaction area
          Positioned(
            left: 0,
            top: 48,
            child: GestureDetector(
              onVerticalDragStart: _handleDragStart,
              onVerticalDragUpdate: _handleDragUpdate,
              child: SizedBox(
                width: 63,
                height: 180.18,
                child: Stack(
                  children: [
                    // Track background
                    Positioned(
                      left: 26.46,
                      child: Container(
                        width: 10.08,
                        height: 180.18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D4251),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 2.52,
                            height: 172.62,
                            color: const Color(0xFF1B1D22),
                          ),
                        ),
                      ),
                    ),

                    // Tick marks
                    ...List.generate(11, (index) {
                      final progress = (widget.value - widget.min) / (widget.max - widget.min);
                      // Reverse index to make it start from bottom
                      final reversedIndex = 10 - index;
                      final active = reversedIndex <= (progress * 10).floor();
                      return Positioned(
                        left: 0,
                        top: index * 16.5,
                        child: Row(
                          children: [
                            _buildTickMark(active),
                            const SizedBox(width: 40.32),
                            _buildTickMark(active),
                          ],
                        ),
                      );
                    }),

                    // Handler
                    Positioned(
                      left: 5.04,
                      top: (1 - (widget.value - widget.min) / (widget.max - widget.min)) * (_sliderHeight - 30.24),
                      child: Container(
                        width: 52.92,
                        height: 30.24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF2A2D34), Color(0xFF43464F)],
                          ),
                          borderRadius: BorderRadius.circular(5.04),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 50.4,
                              height: 10.08,
                              margin: const EdgeInsets.only(top: 3.78),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Color(0x2ECEDAFF), Color(0x00CEDAFF)],
                                  stops: [0.375, 1.0],
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
            ),
          ),

          // Scale numbers
          Positioned(
            right: 4.75,
            top: 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(5, (index) {
                final number = 5 - index;
                return Container(
                  width: 8,
                  height: 42,
                  alignment: Alignment.center,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0x80FFFFFF),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Unit label
          Positioned(
            right: 0,
            top: 9,
            child: Text(
              widget.unit,
              style: const TextStyle(
                fontFamily: 'Acumin Pro Wide',
                fontSize: 16,
                height: 19/16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
