import 'package:flutter/material.dart';

class PatternSummary extends StatelessWidget {
  final Size size;
  final List<String> outsideValues;
  final List<String> insideValues;

  const PatternSummary({
    super.key,
    required this.size,
    required this.outsideValues,
    required this.insideValues,
  });

  @override
  Widget build(BuildContext context) {
    // Helper for cell background color
    Color getCellColor(int index) {
      if (index == 0) return Colors.transparent;
      if (index >= 1 && index <= 7) {
        // OUT
        return Colors.green.shade800.withOpacity(0.13);
      }
      if (index >= 8 && index <= 14) {
        // IN
        return Colors.purple.shade800.withOpacity(0.13);
      }
      // INTENSITY, FREQUENCY, TIME
      return Colors.grey.withOpacity(0.08);
    }

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
            '    Pattern summary',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.012,
            ),
          ),
        ),
        SingleChildScrollView(
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
            ],
            rows: [
              DataRow(
                cells: List.generate(1 + 7 + 7 + 3, (i) {
                  String text;
                  if (i == 0) {
                    text = '1';
                  } else if (i >= 1 && i <= 7) {
                    text = outsideValues[i - 1];
                  } else if (i >= 8 && i <= 14) {
                    text = insideValues[i - 8];
                  } else if (i == 15) {
                    text = '50';
                  } else if (i == 16) {
                    text = '60';
                  } else {
                    text = '2.0';
                  }
                  return DataCell(
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.003,
                        vertical: size.height * 0.004,
                      ),
                      width: cellSize,
                      height: cellSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: getCellColor(i),
                        borderRadius: BorderRadius.circular(cellRadius),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: size.width * 0.009, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
              DataRow(
                cells: List.generate(1 + 7 + 7 + 3, (i) {
                  String text;
                  if (i == 0) {
                    text = '2';
                  } else if (i >= 1 && i <= 7) {
                    text = outsideValues[i - 1];
                  } else if (i >= 8 && i <= 14) {
                    text = insideValues[i - 8];
                  } else if (i == 15) {
                    text = '70';
                  } else if (i == 16) {
                    text = '80';
                  } else {
                    text = '3.5';
                  }
                  return DataCell(
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.003,
                        vertical: size.height * 0.004,
                      ),
                      width: cellSize,
                      height: cellSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: getCellColor(i),
                        borderRadius: BorderRadius.circular(cellRadius),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: size.width * 0.009, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
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
