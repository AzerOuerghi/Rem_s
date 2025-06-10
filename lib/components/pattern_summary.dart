import 'package:flutter/material.dart';
import '../services/config_service.dart';

class PatternSummary extends StatefulWidget {
  final Size size;
  final List<Map<String, dynamic>> steps;
  final Function(int) onDeleteStep;
  final Function(int) onEditStep;
  final double scale;
  final int? editingIndex;

  const PatternSummary({
    super.key,
    required this.size,
    required this.steps,
    required this.onDeleteStep,
    required this.onEditStep,
    this.scale = 1.0,
    this.editingIndex,
  });

  @override
  State<PatternSummary> createState() => _PatternSummaryState();
}

class _PatternSummaryState extends State<PatternSummary> {
  int? numBladders;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await ConfigService.getInstance();
    setState(() {
      numBladders = config.numBladders;
    });
  }

  Color getCellColor(int index, int stepIndex) {
    if (index == 0) {
      return widget.editingIndex == stepIndex 
          ? Colors.yellow.withOpacity(0.3) 
          : Colors.transparent;
    }
    
    final bladderCount = widget.steps.isNotEmpty 
        ? (widget.steps[0]['bladders'] as List).length 
        : numBladders ?? 10;
        
    if (index >= 1 && index <= bladderCount) {
      return widget.editingIndex == stepIndex
          ? Colors.green.withOpacity(0.5)
          : Colors.green.shade800.withOpacity(0.3);
    }
    return Colors.grey.withOpacity(0.08);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final double cellSize = widget.size.width * 0.045 * scale;
    final double cellRadius = widget.size.width * 0.006 * scale;
    
    // Get number of bladders from steps or config, fallback to 10
    final bladderCount = widget.steps.isNotEmpty 
        ? (widget.steps[0]['bladders'] as List).length 
        : numBladders ?? 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: widget.size.width * 0.008 * scale,
            bottom: widget.size.height * 0.008 * scale,
          ),
          child: Text(
            'Pattern summary',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: widget.size.width * 0.012 * scale,
            ),
          ),
        ),
        // Add height constraint and scroll view
        SizedBox(
          height: widget.size.height * 0.2 * scale, // Fixed height for the table container
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: widget.size.height * 0.052 * scale,
                  dataRowHeight: widget.size.height * 0.052 * scale,
                  columnSpacing: widget.size.width * 0.006 * scale,
                  columns: [
                    DataColumn(
                      label: _squareHeader('ID', cellSize, cellRadius, Colors.transparent, scale),
                    ),
                    ...List.generate(
                      bladderCount,
                      (i) => DataColumn(
                        label: _squareHeader(
                          'BLD${i + 1}',
                          cellSize,
                          cellRadius,
                          Colors.green.shade800.withOpacity(0.6),
                          scale,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: _squareHeader('INTENSITY', cellSize, cellRadius, Colors.grey.withOpacity(0.6), scale),
                    ),
                    DataColumn(
                      label: _squareHeader('FREQUENCY', cellSize, cellRadius, Colors.grey.withOpacity(0.6), scale),
                    ),
                    DataColumn(
                      label: _squareHeader('TIME', cellSize, cellRadius, Colors.grey.withOpacity(0.6), scale),
                    ),
                    DataColumn(
                      label: _squareHeader('Actions', cellSize, cellRadius, Colors.transparent, scale),
                    ),
                  ],
                  rows: List.generate(widget.steps.length, (index) {
                    final step = widget.steps[index];
                    final bladders = step['bladders'] as List;
                    return DataRow(
                      cells: [
                        DataCell(_buildCell(step['step_id'].toString(), 0, index)),
                        ...List.generate(
                          bladders.length,
                          (i) => DataCell(_buildCell(bladders[i]['value'], i + 1, index)),
                        ),
                        DataCell(_buildCell(step['intensity'].round().toString(), 11, index)),
                        DataCell(_buildCell(step['frequency'].round().toString(), 12, index)),
                        DataCell(_buildCell((step['duration_ms'] / 1000).toStringAsFixed(2), 13, index)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, 
                                  color: Colors.white,
                                  size: widget.size.width * 0.015 * scale,
                                ),
                                onPressed: () => widget.onEditStep(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                  color: Colors.red,
                                  size: widget.size.width * 0.015 * scale,
                                ),
                                onPressed: () => widget.onDeleteStep(index),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text, int index, int stepIndex) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.size.width * 0.003 * widget.scale,
        vertical: widget.size.height * 0.004 * widget.scale,
      ),
      width: widget.size.width * 0.045 * widget.scale,
      height: widget.size.width * 0.045 * widget.scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: getCellColor(index, stepIndex),
        borderRadius: BorderRadius.circular(widget.size.width * 0.006 * widget.scale),
        border: widget.editingIndex == stepIndex ? Border.all(
          color: Colors.yellow.withOpacity(0.5),
          width: 2,
        ) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: widget.size.width * 0.009 * widget.scale,
          color: Colors.white,
          fontWeight: index == 0 && widget.editingIndex == stepIndex 
              ? FontWeight.bold 
              : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _squareHeader(String label, double cellSize, double cellRadius, Color color, double scale) {
    return Container(
      width: cellSize,
      height: cellSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(cellRadius),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: cellSize * 0.2, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
