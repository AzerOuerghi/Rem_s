import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'rem_studio_screen.dart';
import 'new_project_screen.dart';
import 'new_project_configuration_screen.dart';
import 'new_project_advanced_options_screen.dart';
import 'new_project_preconfigured_templates_screen.dart';

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
        '/new_project': (context) => const NewProjectScreen(),
        '/new_project_configuration': (context) => const NewProjectConfigurationScreen(),
        '/new_project_advanced_options': (context) => const NewProjectAdvancedOptionsScreen(),
        '/new_project_preconfigured_templates': (context) => const NewProjectPreconfiguredTemplatesScreen(),
      },
    );
  }
}
