import 'dart:convert';
import 'package:flutter/services.dart';

class ConfigService {
  static ConfigService? _instance;
  int numBladders = 10; // Default value
  
  static Future<ConfigService> getInstance() async {
    if (_instance == null) {
      final service = ConfigService();
      await service.initialize();
      _instance = service;
    }
    return _instance!;
  }

  Future<void> initialize() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final config = json.decode(configString);
      numBladders = config['num_bladders'] ?? 10;
    } catch (e) {
      print('Error loading config: $e');
      // Keep default value of 10
    }
  }
}
