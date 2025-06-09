import 'package:flutter/material.dart';
import 'components/vertical_slider.dart';

class NewProjectAdvancedOptionsScreen extends StatefulWidget {
  const NewProjectAdvancedOptionsScreen({super.key});

  @override
  State<NewProjectAdvancedOptionsScreen> createState() => _NewProjectAdvancedOptionsScreenState();
}

class _NewProjectAdvancedOptionsScreenState extends State<NewProjectAdvancedOptionsScreen> {
  double _intensity = 50;
  double _frequency = 50;
  double _duration = 2.5;
  bool _looping = false;

  void _goBack() {
    Navigator.pushReplacementNamed(context, '/new_project');
  }

  void _proceed() {
    // Save advanced options if needed, then go to next step or main screen
    Navigator.pushReplacementNamed(context, '/customise');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 1920).clamp(0.5, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          // Title
          Positioned(
            top: 34 * scale,
            left: size.width / 2 - (341 * scale) / 2,
            child: SizedBox(
              width: 341 * scale,
              height: 58 * scale,
              child: Text(
                'REM STUDIO',
                style: TextStyle(
                  fontFamily: 'Acumin Pro Wide',
                  fontSize: 48 * scale,
                  fontWeight: FontWeight.w700,
                  height: 58 / 48,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 16 * scale,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Main Card
          Center(
            child: Container(
              width: 0.7 * size.width,
              height: 0.6 * size.height,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.82),
                borderRadius: BorderRadius.circular(18 * scale),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.2 * scale),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 60 * scale, vertical: 40 * scale),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Sliders and looping
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NEW PROJECT CREATION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22 * scale,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 40 * scale),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Intensity
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 4 * scale),
                                        child: Text(
                                          '#value',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13 * scale,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      VerticalSlider(
                                        value: _intensity,
                                        min: 0,
                                        max: 100,
                                        divisions: 20,
                                        onChanged: (v) => setState(() => _intensity = v),
                                        label: 'DEFAULT INTENSITY',
                                        unit: '(%)',
                                        valueLabel: _intensity.round().toString(),
                                        scale: scale,
                                      ),
                                      SizedBox(height: 8 * scale),
                                      Text(
                                        'DEFAULT\nINTENSITY\n(%)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13 * scale,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  // Frequency
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 4 * scale),
                                        child: Text(
                                          '#value',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13 * scale,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      VerticalSlider(
                                        value: _frequency,
                                        min: 0,
                                        max: 100,
                                        divisions: 20,
                                        onChanged: (v) => setState(() => _frequency = v),
                                        label: 'DEFAULT PULSE FREQUENCY',
                                        unit: '(Hz)',
                                        valueLabel: _frequency.round().toString(),
                                        scale: scale,
                                      ),
                                      SizedBox(height: 8 * scale),
                                      Text(
                                        'DEFAULT\nPULSE FREQUENCY\n(Hz)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13 * scale,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  // Duration
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 4 * scale),
                                        child: Text(
                                          '#value',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13 * scale,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      VerticalSlider(
                                        value: _duration,
                                        min: 0,
                                        max: 5,
                                        divisions: 10,
                                        onChanged: (v) => setState(() => _duration = v),
                                        label: 'DEFAULT DURATION / STEP',
                                        unit: '(ms)',
                                        valueLabel: _duration.toStringAsFixed(2),
                                        scale: scale,
                                      ),
                                      SizedBox(height: 8 * scale),
                                      Text(
                                        'DEFAULT\nDURATION / STEP\n(ms)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13 * scale,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 40 * scale),
                              Row(
                                children: [
                                  Container(
                                    width: 180 * scale,
                                    child: Text(
                                      'enable looping',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16 * scale,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16 * scale),
                                  SizedBox(
                                    width: 32 * scale,
                                    height: 32 * scale,
                                    child: Checkbox(
                                      value: _looping,
                                      onChanged: (val) => setState(() => _looping = val ?? false),
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      side: BorderSide(color: Colors.white54, width: 1.2),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4 * scale)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Right: Menu
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 40 * scale, top: 10 * scale),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/new_project');
                                  },
                                  child: Text(
                                    'BASIC DETAILS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15 * scale,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32 * scale),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/new_project_configuration');
                                  },
                                  child: Text(
                                    'PATTERN\nCONFIGURATION',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * scale,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.1,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(height: 32 * scale),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/new_project_advanced_options');
                                  },
                                  child: Text(
                                    'ADVANCED OPTIONS',
                                    style: TextStyle(
                                      color: Colors.yellow[600],
                                      fontSize: 13 * scale,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.1,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(height: 32 * scale),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/new_project_preconfigured_templates');
                                  },
                                  child: Text(
                                    'PRECONFIGURED\nTEMPLATES',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * scale,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.1,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Back arrow (bottom left)
                  Positioned(
                    left: 24 * scale,
                    bottom: 24 * scale,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 32 * scale),
                      onPressed: _goBack,
                    ),
                  ),
                  // OK button (bottom right)
                  Positioned(
                    right: 24 * scale,
                    bottom: 24 * scale,
                    child: GestureDetector(
                      onTap: _proceed,
                      child: Row(
                        children: [
                          Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * scale,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 8 * scale),
                          Icon(Icons.pan_tool_alt, color: Colors.white, size: 24 * scale),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // FORVIA at the bottom center
          Positioned(
            bottom: 24 * scale,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'FORVIA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22 * scale,
                  letterSpacing: 2,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
