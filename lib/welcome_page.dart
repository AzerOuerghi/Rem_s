import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double outerRadius = 18;
    final double cardRadius = 18;
    final double cardBorderWidth = 1.2;
    final double dotRadius = 6;
    final double dotBorder = 1.2;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Optional: overlay for darkening
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.04),
                Text(
                  'REM STUDIO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.032,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: size.width * 0.82,
                        height: size.height * 0.52,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.82),
                          borderRadius: BorderRadius.circular(cardRadius),
                          border: Border.all(color: Colors.white.withOpacity(0.08), width: cardBorderWidth),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _WelcomeButton(
                                  label: 'NEW PROJECT',
                                  onTap: () => Navigator.pushReplacementNamed(context, '/customise'),
                                  size: size,
                                ),
                                SizedBox(width: size.width * 0.03),
                                _WelcomeButton(
                                  label: 'LOAD PROJECT',
                                  onTap: () {},
                                  size: size,
                                ),
                                SizedBox(width: size.width * 0.03),
                                _WelcomeButton(
                                  label: 'IMPORT PATTERN',
                                  onTap: () {},
                                  size: size,
                                ),
                                SizedBox(width: size.width * 0.03),
                                _WelcomeButton(
                                  label: 'TEMPLATES',
                                  onTap: () {},
                                  size: size,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Corner dots
                      Positioned(
                        left: 8, top: 8,
                        child: _CornerDot(dotRadius, dotBorder),
                      ),
                      Positioned(
                        right: 8, top: 8,
                        child: _CornerDot(dotRadius, dotBorder),
                      ),
                      Positioned(
                        left: 8, bottom: 8,
                        child: _CornerDot(dotRadius, dotBorder),
                      ),
                      Positioned(
                        right: 8, bottom: 8,
                        child: _CornerDot(dotRadius, dotBorder),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.02),
                  child: Center(
                    child: Text(
                      'FORVIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.018,
                        letterSpacing: 2,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Size size;

  const _WelcomeButton({
    required this.label,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.width * 0.18,
          height: size.height * 0.07,
          margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.014,
                letterSpacing: 1.2,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerDot extends StatelessWidget {
  final double radius;
  final double borderWidth;
  const _CornerDot(this.radius, this.borderWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white.withOpacity(0.18), width: borderWidth),
        shape: BoxShape.circle,
      ),
    );
  }
}
