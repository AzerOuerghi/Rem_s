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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await ConfigService.getInstance();
    setState(() {
      numBladders = config.numBladders;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    // Use available width, clamp to max 1921px
    final double width = widget.size.width.clamp(0, 1921 * scale);
    final double height = 300 * scale;
    // Adjust header and content widths to fit inside available width
    final double margin = 110 * scale;
    final double headerHeight = 52 * scale;
    final double headerTop = 64 * scale;
    final double headerLeft = 22 * scale;
    final double headerWidth = width - headerLeft - margin;
    final double titleLeft = 40 * scale;
    final double titleTop = 25 * scale;
    final double idLeft = 32 * scale;
    final double idTop = 74 * scale;
    final double idBoxWidth = 64 * scale;
    final double idBoxHeight = 32 * scale;
    final double bldStartLeft = 119 * scale;
    final double bldTop = 74 * scale;
    final double bldBoxWidth = 72 * scale;
    final double bldBoxHeight = 32 * scale;
    final double metricBoxWidth = 61 * scale;
    final double metricBoxHeight = 32 * scale;
    final double metricBoxGap = 10 * scale;
    // Place metrics and clear all at the right edge, but keep inside width
    final double metricsLeft = width - margin - (3 * metricBoxWidth + 2 * metricBoxGap + 84 * scale);
    final double metricsTop = 74 * scale;
    final double clearAllLeft = width - margin - 163 * scale;
    final double clearAllTop = 10 * scale;
    final double clearAllWidth = 163 * scale;
    final double clearAllHeight = 44 * scale;

    // Get number of bladders from steps or config, fallback to 10
    final bladderCount = widget.steps.isNotEmpty
        ? (widget.steps[0]['bladders'] as List).length
        : numBladders ?? 10;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Main background
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(136, 136, 136, 0.2),
                borderRadius: BorderRadius.circular(18 * scale),
                // Simulate blur with a subtle shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 50 * scale,
                  ),
                ],
              ),
            ),
          ),
          // Header background
          Positioned(
            left: headerLeft,
            top: headerTop,
            child: Container(
              width: headerWidth,
              height: headerHeight,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(136, 136, 136, 0.2),
                borderRadius: BorderRadius.circular(18 * scale),
              ),
            ),
          ),
          // Title
          Positioned(
            left: titleLeft,
            top: titleTop,
            child: Text(
              'PATTERN SUMMARY',
              style: TextStyle(
                fontFamily: 'Acumin Pro Wide',
                fontWeight: FontWeight.w700,
                fontSize: 16 * scale,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    blurRadius: 8 * scale,
                  ),
                ],
              ),
            ),
          ),
          // ID header
          Positioned(
            left: idLeft,
            top: idTop,
            child: Container(
              width: idBoxWidth,
              height: idBoxHeight,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8 * scale),
              ),
              child: Center(
                child: Text(
                  'ID',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16 * scale,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Bladder headers
          ...List.generate(
            bladderCount,
            (i) => Positioned(
              left: bldStartLeft + i * (bldBoxWidth + 8 * scale),
              top: bldTop,
              child: Container(
                width: bldBoxWidth,
                height: bldBoxHeight,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(80, 165, 50, 0.6),
                  border: Border.all(color: const Color(0xFF85E264)),
                  borderRadius: BorderRadius.circular(8 * scale),
                ),
                child: Center(
                  child: Text(
                    'BLD${i + 1}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16 * scale,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Metrics headers (INT., FREQ., DUR.)
          Positioned(
            left: metricsLeft,
            top: metricsTop,
            child: Row(
              children: [
                _metricBox('INT.', metricBoxWidth, metricBoxHeight, scale),
                SizedBox(width: metricBoxGap),
                _metricBox('FREQ.', metricBoxWidth, metricBoxHeight, scale),
                SizedBox(width: metricBoxGap),
                _metricBox('DUR.', metricBoxWidth, metricBoxHeight, scale),
              ],
            ),
          ),

          // Table rows (IDs and values)
          Positioned(
            left: 0,
            top: idTop + idBoxHeight + 10 * scale,
            right: 0,
            bottom: 10 * scale,
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple.withAlpha(0),
                    Colors.purple,
                  ],
                  stops: [0.95, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: RawScrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                thumbColor: Colors.white.withOpacity(0.3),
                trackColor: Colors.white.withOpacity(0.1),
                radius: Radius.circular(20),
                thickness: 8 * scale,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16 * scale),
                    child: Column(
                      children: List.generate(widget.steps.length, (rowIdx) {
                        final step = widget.steps[rowIdx];
                        final bladders = step['bladders'] as List;
                        final isEditing = widget.editingIndex == rowIdx;
                        return Container(
                          margin: EdgeInsets.only(bottom: 10 * scale),
                          height: idBoxHeight,
                          child: Stack(
                            children: [
                              if (isEditing)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8 * scale),
                                      border: Border.all(
                                        color: Colors.yellow.withOpacity(0.3),
                                        width: 2 * scale,
                                      ),
                                    ),
                                  ),
                                ),
                              // ID cell with modified decoration for editing state
                              Positioned(
                                left: idLeft,
                                top: 0,
                                child: Container(
                                  width: idBoxWidth,
                                  height: idBoxHeight,
                                  decoration: BoxDecoration(
                                    color: isEditing 
                                        ? Colors.yellow.withOpacity(0.2)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8 * scale),
                                    border: isEditing ? Border.all(
                                      color: Colors.yellow.withOpacity(0.5),
                                      width: 1 * scale,
                                    ) : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      step['step_id'].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: isEditing ? FontWeight.w900 : FontWeight.w700,
                                        fontSize: 16 * scale,
                                        color: isEditing ? Colors.yellow : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Bladder value cells
                              ...List.generate(
                                bladderCount,
                                (i) => Positioned(
                                  left: bldStartLeft + i * (bldBoxWidth + 8 * scale),
                                  top: 0,
                                  child: Container(
                                    width: bldBoxWidth,
                                    height: bldBoxHeight,
                                    decoration: BoxDecoration(
                                      color: bladders[i]['value'] != ''
                                          ? const Color.fromRGBO(80, 165, 50, 0.2)
                                          : Colors.white.withOpacity(0.1),
                                      border: Border.all(color: const Color(0xFF85E264)),
                                      borderRadius: BorderRadius.circular(8 * scale),
                                    ),
                                    child: Center(
                                      child: Text(
                                        bladders[i]['value'] ?? '',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16 * scale,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // INT, FREQ, DUR cells
                              Positioned(
                                left: metricsLeft,
                                top: 0,
                                child: Row(
                                  children: [
                                    _metricBox(step['intensity'].toString(), metricBoxWidth, metricBoxHeight, scale),
                                    SizedBox(width: metricBoxGap),
                                    _metricBox(step['frequency'].toString(), metricBoxWidth, metricBoxHeight, scale),
                                    SizedBox(width: metricBoxGap),
                                    _metricBox((step['duration_ms'] / 1000).toStringAsFixed(2), metricBoxWidth, metricBoxHeight, scale),
                                  ],
                                ),
                              ),
                              // Edit/Delete buttons
                              Positioned(
                                left: metricsLeft + 3 * (metricBoxWidth + metricBoxGap) + 20 * scale,
                                top: 0,
                                child: Row(
                                  children: [
                                    _iconButton(Icons.edit, Colors.white, () => widget.onEditStep(rowIdx), scale),
                                    SizedBox(width: 10 * scale),
                                    _iconButton(Icons.delete, Colors.red, () => widget.onDeleteStep(rowIdx), scale),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricBox(String label, double width, double height, double scale) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8 * scale),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 16 * scale,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onTap, double scale) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32 * scale,
        height: 32 * scale,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8 * scale),
        ),
        child: Icon(
          icon,
          color: color,
          size: 16 * scale,
        ),
      ),
    );
  }
}
