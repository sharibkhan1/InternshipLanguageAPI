import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationProvider extends ChangeNotifier {
  String _selectedLanguage = 'en';
  bool _isLoading = false;

  final Map<String, String> _translations = {
    'appTitle': 'My App',
    'addToCart': 'Add to Cart',
    'helloEveryone': 'Hello Everyone',
  };

  final Map<String, String> _translatedTexts = {};

  String get selectedLanguage => _selectedLanguage;
  bool get isLoading => _isLoading;

  final Map<String, String> _languages = {
    'English': 'en',
    'Hindi': 'hi',
    'Spanish': 'es',
    'Tamil': 'ta',
  };

  Map<String, String> get languages => _languages;

  Map<String, String> get translatedTexts {
    if (_translatedTexts.isEmpty) {
      return _translations;
    }
    return _translatedTexts;
  }

  Future<void> translateTexts(String targetLanguage) async {
    _isLoading = true;
    notifyListeners();

    final String apiUrl =
        "https://deep-translate1.p.rapidapi.com/language/translate/v2";

    for (String key in _translations.keys) {
      final Map<String, dynamic> payload = {
        "q": _translations[key],
        "source": "en",
        "target": targetLanguage,
      };

      final Map<String, String> headers = {
        "x-rapidapi-key": "677e81e9c9msh70dff0bdfb0b8a8p1ec20fjsn0c09e57db105",
        "x-rapidapi-host": "deep-translate1.p.rapidapi.com",
        "Content-Type": "application/json",
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _translatedTexts[key] = data['data']['translations']['translatedText'];
      } else {
        _translatedTexts[key] =
        'Failed to translate text. Status code: ${response.statusCode}';
      }
    }

    _selectedLanguage = targetLanguage;
    _isLoading = false;
    notifyListeners();
  }

  Future<String> translateInputText(String text, String targetLanguage) async {
    final String apiUrl =
        "https://deep-translate1.p.rapidapi.com/language/translate/v2";

    final Map<String, dynamic> payload = {
      "q": text,
      "source": "en",
      "target": targetLanguage,
    };

    final Map<String, String> headers = {
      "x-rapidapi-key": "677e81e9c9msh70dff0bdfb0b8a8p1ec20fjsn0c09e57db105",
      "x-rapidapi-host": "deep-translate1.p.rapidapi.com",
      "Content-Type": "application/json",
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['data']['translations']['translatedText'];
    } else {
      return 'Failed to translate text. Status code: ${response.statusCode}';
    }
  }
}
