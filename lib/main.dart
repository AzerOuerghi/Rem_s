import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'rem_studio_screen.dart';

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
