import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  // Layout settings
  bool _showYamlPreview = true;
  bool _showVersion = true;

  // Editor settings
  bool _autoSave = false;
  String _defaultVersion = '3';
  
  // Appearance settings
  bool _isDarkMode = true;
  double _fontSize = 14.0;

  // Advanced settings
  bool _experimentalFeatures = false;
  String _exportLocation = '';

  // Getters
  bool get showYamlPreview => _showYamlPreview;
  bool get showVersion => _showVersion;
  bool get autoSave => _autoSave;
  String get defaultVersion => _defaultVersion;
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  bool get experimentalFeatures => _experimentalFeatures;
  String get exportLocation => _exportLocation;

  // Setters with notification
  void setShowYamlPreview(bool value) {
    _showYamlPreview = value;
    notifyListeners();
  }

  void setShowVersion(bool value) {
    _showVersion = value;
    notifyListeners();
  }

  void setAutoSave(bool value) {
    _autoSave = value;
    notifyListeners();
  }

  void setDefaultVersion(String value) {
    _defaultVersion = value;
    notifyListeners();
  }

  void setIsDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setFontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  void setExperimentalFeatures(bool value) {
    _experimentalFeatures = value;
    notifyListeners();
  }

  void setExportLocation(String value) {
    _exportLocation = value;
    notifyListeners();
  }
}
