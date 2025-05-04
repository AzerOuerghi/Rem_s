import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final double padding;
  final double containerRadius;
  final double buttonWidth;
  final double buttonHeight;
  final Size size;

  const ActionButtons({
    super.key,
    required this.padding,
    required this.containerRadius,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Text('ACTIONS', style: TextStyle(fontSize: size.width * 0.009)),
          SizedBox(height: size.height * 0.01),
          ...['ADD STEP', 'EDIT STEP', 'CLEAR STEP', 'CLEAR ALL', 'EXPORT', 'SIMULATE']
              .map((text) => Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.006),
                    child: SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {},
                        child: Text(text, style: TextStyle(fontSize: size.width * 0.009)),
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
