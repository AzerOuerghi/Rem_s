import 'package:flutter/material.dart';
import 'components/pattern_editor.dart';
import 'components/simulator.dart';
import 'components/action_buttons.dart';
import 'components/pattern_summary.dart';
import 'components/dotted_card.dart';
import 'welcome_page.dart';

void main() => runApp(const RemStudioApp());

class RemStudioApp extends StatelessWidget {
  const RemStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REM Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/customise': (context) => const RemStudioScreen(),
      },
    );
  }
}

class RemStudioScreen extends StatefulWidget {
  const RemStudioScreen({super.key});

  @override
  State<RemStudioScreen> createState() => _RemStudioScreenState();
}

class _RemStudioScreenState extends State<RemStudioScreen> {
  final List<String> options = ['1', '2', '3'];
  final List<String> outsideValues = List.generate(7, (index) => '1');
  final List<String> insideValues = List.generate(7, (index) => '1');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.012;
    final double containerRadius = size.width * 0.008;
    final double nodeWidth = size.width * 0.075;
    final double nodeHeight = size.height * 0.038;
    final double sliderHeight = size.height * 0.20;
    final double buttonWidth = size.width * 0.11;
    final double buttonHeight = size.height * 0.038;
    final double summaryHeight = size.height * 0.15;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Stack(
        children: [
          // Background image for customize section
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
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.012),
                Text(
                  'REM STUDIO',
                  style: TextStyle(
                    fontSize: size.width * 0.022,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: size.height * 0.016),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: PatternEditor(
                          options: options,
                          outsideValues: outsideValues,
                          insideValues: insideValues,
                          onOutsideChanged: (i, v) => setState(() => outsideValues[i] = v),
                          onInsideChanged: (i, v) => setState(() => insideValues[i] = v),
                          padding: padding,
                          containerRadius: containerRadius,
                          nodeWidth: nodeWidth,
                          nodeHeight: nodeHeight,
                          sliderHeight: sliderHeight,
                          size: size,
                        ),
                      ),
                      SizedBox(width: size.width * 0.015),
                      Expanded(
                        child: DottedCard(
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: containerRadius * 2,
                          child: Simulator(
                            padding: padding,
                            containerRadius: containerRadius,
                            size: size,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.015),
                      DottedCard(
                        width: buttonWidth + padding * 2,
                        height: double.infinity,
                        borderRadius: containerRadius * 2,
                        child: ActionButtons(
                          padding: padding,
                          containerRadius: containerRadius,
                          buttonWidth: buttonWidth,
                          buttonHeight: buttonHeight,
                          size: size,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.012),
                DottedCard(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: PatternSummary(
                      size: size,
                      outsideValues: outsideValues,
                      insideValues: insideValues,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.012),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
