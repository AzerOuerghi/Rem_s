import 'package:flutter/material.dart';

class NewProjectPreconfiguredTemplatesScreen extends StatefulWidget {
  const NewProjectPreconfiguredTemplatesScreen({super.key});

  @override
  State<NewProjectPreconfiguredTemplatesScreen> createState() => _NewProjectPreconfiguredTemplatesScreenState();
}

class _NewProjectPreconfiguredTemplatesScreenState extends State<NewProjectPreconfiguredTemplatesScreen> {
  String _selectedPattern = 'cat paw';
  final List<String> _patterns = ['cat paw', 'wave', 'zigzag', 'custom'];
  String? _importedFile;

  void _goBack() {
    Navigator.pushReplacementNamed(context, '/new_project');
  }

  void _goToNext() {
    Navigator.pushReplacementNamed(context, '/customise');
  }

  void _goToBasicDetails() {
    Navigator.pushReplacementNamed(context, '/new_project');
  }

  void _goToPatternConfiguration() {
    Navigator.pushReplacementNamed(context, '/new_project_configuration');
  }

  void _goToAdvancedOptions() {
    Navigator.pushReplacementNamed(context, '/new_project_advanced_options');
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60 * scale, vertical: 40 * scale),
                    child: Row(
                      children: [
                        // Left: Preset patterns and import
                        Expanded(
                          flex: 3,
                          child: Column(
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
                              Text(
                                'PRESET PATTERNS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16 * scale,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: 12 * scale),
                              Container(
                                width: 320 * scale,
                                height: 36 * scale,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(6 * scale),
                                  border: Border.all(color: Colors.white38, width: 1.2),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedPattern,
                                    dropdownColor: Colors.black,
                                    style: TextStyle(color: Colors.white, fontSize: 16 * scale),
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 28 * scale),
                                    items: _patterns.map((pattern) {
                                      return DropdownMenuItem<String>(
                                        value: pattern,
                                        child: Text(pattern),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedPattern = val);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 40 * scale),
                              Text(
                                'IMPORT PATTERN FILE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16 * scale,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: 12 * scale),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 36 * scale,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(6 * scale),
                                        border: Border.all(color: Colors.white38, width: 1.2),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                                          child: Text(
                                            _importedFile ?? 'browse',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16 * scale,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16 * scale),
                                  SizedBox(
                                    width: 120 * scale,
                                    height: 36 * scale,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: implement file picker
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white24,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6 * scale),
                                        ),
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text('browse'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20 * scale),
                              SizedBox(
                                width: 120 * scale,
                                height: 36 * scale,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: implement import logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6 * scale),
                                    ),
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text('import'),
                                ),
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
                                    'ADVANCED\nOPTIONS',
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
                                    Navigator.pushReplacementNamed(context, '/new_project_preconfigured_templates');
                                  },
                                  child: Text(
                                    'PRECONFIGURED\nTEMPLATES',
                                    style: TextStyle(
                                      color: Colors.yellow[600],
                                      fontSize: 13 * scale,
                                      fontWeight: FontWeight.w700,
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
                      onTap: _goToNext,
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
