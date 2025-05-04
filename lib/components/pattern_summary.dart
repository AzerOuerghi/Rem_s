import 'package:flutter/material.dart';

class PatternSummary extends StatelessWidget {
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

  // Add this method to define cell colors
  Color getCellColor(int index) {
    if (index == 0) return Colors.transparent;
    if (index >= 1 && index <= 7) {
      // OUT nodes
      return Colors.green.shade800.withOpacity(0.13);
    }
    if (index >= 8 && index <= 14) {
      // IN nodes
      return Colors.purple.shade800.withOpacity(0.13);
    }
    // INTENSITY, FREQUENCY, TIME
    return Colors.grey.withOpacity(0.08);
  }

  @override
  Widget build(BuildContext context) {
    final double cellSize = size.width * 0.045;
    final double cellRadius = size.width * 0.006;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.008,
            bottom: size.height * 0.008,
          ),
          child: Text(
            'Pattern summary',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.012,
            ),
          ),
        ),
        // Add height constraint and scroll view
        SizedBox(
          height: size.height * 0.2, // Fixed height for the table container
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: size.height * 0.052,
                  dataRowHeight: size.height * 0.052,
                  columnSpacing: size.width * 0.006,
                  columns: [
                    DataColumn(
                      label: _squareHeader('ID', cellSize, cellRadius, Colors.transparent),
                    ),
                    ...List.generate(
                      7,
                      (i) => DataColumn(
                        label: _squareHeader(
                          'OUT${i + 1}',
                          cellSize,
                          cellRadius,
                          Colors.green.shade800.withOpacity(0.6),
                        ),
                      ),
                    ),
                    ...List.generate(
                      7,
                      (i) => DataColumn(
                        label: _squareHeader(
                          'IN${i + 1}',
                          cellSize,
                          cellRadius,
                          Colors.purple.shade800.withOpacity(0.6),
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
                  rows: List.generate(steps.length, (index) {
                    final step = steps[index];
                    return DataRow(
                      cells: [
                        DataCell(_buildCell((index + 1).toString(), 0)),
                        ...List.generate(7, (i) => 
                          DataCell(_buildCell(step['outsideValues'][i], i + 1))),
                        ...List.generate(7, (i) => 
                          DataCell(_buildCell(step['insideValues'][i], i + 8))),
                        DataCell(_buildCell(step['intensity'].round().toString(), 15)),
                        DataCell(_buildCell(step['frequency'].round().toString(), 16)),
                        DataCell(_buildCell(step['duration'].toStringAsFixed(2), 17)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, 
                                  color: Colors.white,
                                  size: size.width * 0.015,
                                ),
                                onPressed: () => onEditStep(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                  color: Colors.red,
                                  size: size.width * 0.015,
                                ),
                                onPressed: () => onDeleteStep(index),
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
        horizontal: size.width * 0.003,
        vertical: size.height * 0.004,
      ),
      width: size.width * 0.045,
      height: size.width * 0.045,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: getCellColor(index),
        borderRadius: BorderRadius.circular(size.width * 0.006),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: size.width * 0.009,
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
