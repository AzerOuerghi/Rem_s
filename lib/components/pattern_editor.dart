import 'package:flutter/material.dart';
import 'dotted_card.dart';

class PatternEditor extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DottedCard(
            borderRadius: containerRadius,
            child: Padding(
              padding: EdgeInsets.all(padding),
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
                              fontSize: size.width * 0.014)),
                      Row(
                        children: [
                          Text('BACKREST',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: size.width * 0.010)),
                          Switch(
                            value: true,
                            onChanged: (_) {},
                            activeColor: Colors.green,
                          ),
                          Text('CUSHION',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: size.width * 0.010)),
                        ],
                      ),
                    ],
                  ),
                  _buildNodeGrid(),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.012),
          DottedCard(
            borderRadius: containerRadius,
            child: Padding(
              padding: EdgeInsets.all(padding),
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
                color: Colors.white70, fontSize: size.width * 0.009)),
        SizedBox(height: size.height * 0.006),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              return Padding(
                padding: EdgeInsets.only(right: size.width * 0.005),
                child: Container(
                  width: nodeWidth,
                  height: nodeHeight,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.007),
                  decoration: BoxDecoration(
                    color: Colors.green.shade800.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(size.width * 0.008),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: outsideValues[index],
                      dropdownColor: Colors.green.shade900.withOpacity(0.9),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.white, size: size.width * 0.018),
                      style: TextStyle(fontSize: size.width * 0.009),
                      items: options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('OUT${index + 1}: $value',
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          onOutsideChanged(index, newValue);
                        }
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Text('Inside Nodes:',
            style: TextStyle(
                color: Colors.white70, fontSize: size.width * 0.009)),
        SizedBox(height: size.height * 0.006),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              return Padding(
                padding: EdgeInsets.only(right: size.width * 0.005),
                child: Container(
                  width: nodeWidth,
                  height: nodeHeight,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.007),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade800.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(size.width * 0.008),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: insideValues[index],
                      dropdownColor: Colors.purple.shade900.withOpacity(0.9),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.white, size: size.width * 0.018),
                      style: TextStyle(fontSize: size.width * 0.009),
                      items: options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('IN${index + 1}: $value',
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          onInsideChanged(index, newValue);
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
        _buildVerticalSlider('INTENSITY'),
        _buildVerticalSlider('PULSE\nFREQUENCY'),
        _buildVerticalSlider('DURATION/STEP'),
      ],
    );
  }

  Widget _buildVerticalSlider(String label) {
    return Column(
      children: [
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size.width * 0.009)),
        SizedBox(
          height: sliderHeight,
          child: RotatedBox(
            quarterTurns: -1,
            child: Slider(
              value: 0.5,
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}
