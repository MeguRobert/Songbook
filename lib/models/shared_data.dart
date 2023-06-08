import 'package:flutter/material.dart';
import 'package:hello_word/constants.dart';

class SharedData extends ChangeNotifier {
  String language = languages.first;

  void changeLanguage(String newLanguage) {
    language = newLanguage;
    notifyListeners();
  }
}
