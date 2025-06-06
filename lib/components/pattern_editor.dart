import 'package:flutter/material.dart';
import 'dotted_card.dart';
import 'vertical_slider.dart';

class PatternEditor extends StatefulWidget {
  final List<String> options;
  final List<String> bladderValues;
  final Function(int, String) onBladderValueChanged;
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
    required this.bladderValues,
    required this.onBladderValueChanged,
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
        Text('Bladders:',
            style: TextStyle(
                color: Colors.white70, fontSize: widget.size.width * 0.009)),
        SizedBox(height: widget.size.height * 0.006),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(widget.bladderValues.length, (index) {
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
                      value: widget.bladderValues[index].isEmpty ? '' : widget.bladderValues[index],
                      dropdownColor: Colors.green.shade900.withOpacity(0.9),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.white, size: widget.size.width * 0.018),
                      style: TextStyle(fontSize: widget.size.width * 0.009),
                      items: widget.options.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option.isEmpty ? 'BLD${index + 1}' : 'BLD${index + 1}: $option',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          widget.onBladderValueChanged(index, newValue);
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
        VerticalSlider(
          value: widget.intensity,
          min: 0,
          max: 100,
          divisions: 20,
          onChanged: widget.onIntensityChanged,
          label: 'INTENSITY',
          unit: '(%)',
          valueLabel: widget.intensity.round().toString(),
        ),
        VerticalSlider(
          value: widget.pulseFrequency,
          min: 0,
          max: 100,
          divisions: 20,
          onChanged: widget.onFrequencyChanged,
          label: 'PULSE FREQUENCY',
          unit: '(Hz)',
          valueLabel: widget.pulseFrequency.round().toString(),
        ),
        VerticalSlider(
          value: widget.duration,
          min: 0,
          max: 5,
          divisions: 10,
          onChanged: widget.onDurationChanged,
          label: 'DURATION / STEP',
          unit: '(S)',
          valueLabel: widget.duration.toStringAsFixed(2),
        ),
      ],
    );
  }
}
