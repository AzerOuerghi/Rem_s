import 'package:flutter/material.dart';
import '../services/config_service.dart';

class PatternSummary extends StatefulWidget {
  final Size size;
  final List<Map<String, dynamic>> steps;
  final Function(int) onDeleteStep;
  final Function(int) onEditStep;

  const PatternSummary({
    super.key,
    required this.size,
    required this.steps,
    required this.onDeleteStep,
    required this.onEditStep,
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

  Color getCellColor(int index) {
    if (index == 0) return Colors.transparent;
    final bladderCount = widget.steps.isNotEmpty 
        ? (widget.steps[0]['bladders'] as List).length 
        : numBladders ?? 10;
    if (index >= 1 && index <= bladderCount) {
      return Colors.green.shade800.withOpacity(0.3);
    }
    return Colors.grey.withOpacity(0.08);
  }

  @override
  Widget build(BuildContext context) {
    final double cellSize = widget.size.width * 0.045;
    final double cellRadius = widget.size.width * 0.006;
    
    // Get number of bladders from steps or config, fallback to 10
    final bladderCount = widget.steps.isNotEmpty 
        ? (widget.steps[0]['bladders'] as List).length 
        : numBladders ?? 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: widget.size.width * 0.008,
            bottom: widget.size.height * 0.008,
          ),
          child: Text(
            'Pattern summary',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: widget.size.width * 0.012,
            ),
          ),
        ),
        // Add height constraint and scroll view
        SizedBox(
          height: widget.size.height * 0.2, // Fixed height for the table container
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: widget.size.height * 0.052,
                  dataRowHeight: widget.size.height * 0.052,
                  columnSpacing: widget.size.width * 0.006,
                  columns: [
                    DataColumn(
                      label: _squareHeader('ID', cellSize, cellRadius, Colors.transparent),
                    ),
                    ...List.generate(
                      bladderCount,
                      (i) => DataColumn(
                        label: _squareHeader(
                          'BLD${i + 1}',
                          cellSize,
                          cellRadius,
                          Colors.green.shade800.withOpacity(0.6),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: _squareHeader('INTENSITY', cellSize, cellRadius, Colors.grey.withOpacity(0.6)),
                    ),
                    DataColumn(
                      label: _squareHeader('FREQUENCY', cellSize, cellRadius, Colors.grey.withOpacity(0.6)),
                    ),
                    DataColumn(
                      label: _squareHeader('TIME', cellSize, cellRadius, Colors.grey.withOpacity(0.6)),
                    ),
                    DataColumn(
                      label: _squareHeader('Actions', cellSize, cellRadius, Colors.transparent),
                    ),
                  ],
                  rows: List.generate(widget.steps.length, (index) {
                    final step = widget.steps[index];
                    final bladders = step['bladders'] as List;
                    return DataRow(
                      cells: [
                        DataCell(_buildCell(step['step_id'].toString(), 0)),
                        ...List.generate(
                          bladders.length,
                          (i) => DataCell(_buildCell(bladders[i]['value'], i + 1)),
                        ),
                        DataCell(_buildCell(step['intensity'].round().toString(), 11)),
                        DataCell(_buildCell(step['frequency'].round().toString(), 12)),
                        DataCell(_buildCell((step['duration_ms'] / 1000).toStringAsFixed(2), 13)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, 
                                  color: Colors.white,
                                  size: widget.size.width * 0.015,
                                ),
                                onPressed: () => widget.onEditStep(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                  color: Colors.red,
                                  size: widget.size.width * 0.015,
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

  Widget _buildCell(String text, int index) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.size.width * 0.003,
        vertical: widget.size.height * 0.004,
      ),
      width: widget.size.width * 0.045,
      height: widget.size.width * 0.045,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: getCellColor(index),
        borderRadius: BorderRadius.circular(widget.size.width * 0.006),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: widget.size.width * 0.009,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _squareHeader(String label, double cellSize, double cellRadius, Color color) {
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
