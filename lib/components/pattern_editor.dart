import 'package:flutter/material.dart';
import 'dotted_card.dart';

class PatternEditor extends StatefulWidget {
  final List<String> options;
  final List<String> outsideValues;
  final List<String> insideValues;
  final void Function(int, String) onOutsideChanged;
  final void Function(int, String) onInsideChanged;
  final double padding;
  final double containerRadius;
  final double nodeWidth;
  final double nodeHeight;
  final double sliderHeight;
  final Size size;
  final double intensity;
  final double pulseFrequency;
  final double duration;
  final Function(double) onIntensityChanged;
  final Function(double) onFrequencyChanged;
  final Function(double) onDurationChanged;

  const PatternEditor({
    super.key,
    required this.options,
    required this.outsideValues,
    required this.insideValues,
    required this.onOutsideChanged,
    required this.onInsideChanged,
    required this.padding,
    required this.containerRadius,
    required this.nodeWidth,
    required this.nodeHeight,
    required this.sliderHeight,
    required this.size,
    required this.intensity,
    required this.pulseFrequency,
    required this.duration,
    required this.onIntensityChanged,
    required this.onFrequencyChanged,
    required this.onDurationChanged,
  });

  @override
  State<PatternEditor> createState() => _PatternEditorState();
}

class _PatternEditorState extends State<PatternEditor> {
  final List<String> dropdownOptions = ['X', 'P', 'FP'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DottedCard(
            borderRadius: widget.containerRadius,
            child: Padding(
              padding: EdgeInsets.all(widget.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PATTERN EDITOR',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: widget.size.width * 0.014)),
                      Row(
                        children: [
                          Text('BACKREST',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: widget.size.width * 0.010)),
                          Switch(
                            value: true,
                            onChanged: (_) {},
                            activeColor: Colors.green,
                          ),
                          Text('CUSHION',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: widget.size.width * 0.010)),
                        ],
                      ),
                    ],
                  ),
                  _buildNodeGrid(),
                ],
              ),
            ),
          ),
          SizedBox(height: widget.size.height * 0.008),
          DottedCard(
            borderRadius: widget.containerRadius,
            child: Padding(
              padding: EdgeInsets.all(widget.padding),
              child: _buildSliders(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Outside Nodes:',
            style: TextStyle(
                color: Colors.white70, fontSize: widget.size.width * 0.009)),
        SizedBox(height: widget.size.height * 0.006),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              return Padding(
                padding: EdgeInsets.only(right: widget.size.width * 0.005),
                child: Container(
                  width: widget.nodeWidth,
                  height: widget.nodeHeight,
                  padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.007),
                  decoration: BoxDecoration(
                    color: Colors.green.shade800.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(widget.size.width * 0.008),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.outsideValues[index].isEmpty ? '' : widget.outsideValues[index],
                      dropdownColor: Colors.green.shade900.withOpacity(0.9),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.white, size: widget.size.width * 0.018),
                      style: TextStyle(fontSize: widget.size.width * 0.009),
                      items: widget.options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value.isEmpty ? 'OUT${index + 1}' : 'OUT${index + 1}: $value',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          widget.onOutsideChanged(index, newValue);
                        }
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: widget.size.height * 0.008),
        Text('Inside Nodes:',
            style: TextStyle(
                color: Colors.white70, fontSize: widget.size.width * 0.009)),
        SizedBox(height: widget.size.height * 0.006),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              return Padding(
                padding: EdgeInsets.only(right: widget.size.width * 0.005),
                child: Container(
                  width: widget.nodeWidth,
                  height: widget.nodeHeight,
                  padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.007),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade800.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(widget.size.width * 0.008),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.insideValues[index].isEmpty ? '' : widget.insideValues[index],
                      dropdownColor: Colors.purple.shade900.withOpacity(0.9),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.white, size: widget.size.width * 0.018),
                      style: TextStyle(fontSize: widget.size.width * 0.009),
                      items: widget.options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value.isEmpty ? 'IN${index + 1}' : 'IN${index + 1}: $value',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          widget.onInsideChanged(index, newValue);
                        }
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSliders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _verticalSlider(
          value: widget.intensity,
          min: 0,
          max: 100,
          divisions: 20,
          onChanged: widget.onIntensityChanged,
          label: 'INTENSITY',
          unit: '(%)',
          valueLabel: widget.intensity.round().toString(),
          subLabel: '',
        ),
        _verticalSlider(
          value: widget.pulseFrequency,
          min: 0,
          max: 100,
          divisions: 20,
          onChanged: widget.onFrequencyChanged,
          label: 'PULSE FREQUENCY',
          unit: '(Hz)',
          valueLabel: widget.pulseFrequency.round().toString(),
          subLabel: '',
        ),
        _verticalSlider(
          value: widget.duration,
          min: 0,
          max: 5,
          divisions: 10,
          onChanged: widget.onDurationChanged,
          label: 'DURATION / STEP',
          unit: '(ms)',
          valueLabel: widget.duration.toStringAsFixed(2),
          subLabel: '',
        ),
      ],
    );
  }

  Widget _verticalSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String label,
    required String unit,
    required String valueLabel,
    required String subLabel,
  }) {
    final sliderHeight = widget.size.height * 0.13;
    final sliderWidth = widget.size.width * 0.08; // Reduced width since we removed axis

    return SizedBox(
      width: sliderWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(label, style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: widget.size.width * 0.009,
          )),
          Text(unit, style: TextStyle(
            color: Colors.white70,
            fontSize: widget.size.width * 0.007,
            fontStyle: FontStyle.italic,
          )),
          const SizedBox(height: 4),
          // Value display
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '#$valueLabel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: widget.size.width * 0.010,
              ),
            ),
          ),
          // Slider
          SizedBox(
            height: sliderHeight,
            child: Center(
              child: RotatedBox(
                quarterTurns: -1,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white24,
                  ),
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
