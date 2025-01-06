import 'package:flutter/material.dart';

class CheckboxProvider extends ChangeNotifier {
  
  bool _hasImage = false;
  bool get hasImage => _hasImage;

  void toggleHasImage() {
    _hasImage = !_hasImage;
    notifyListeners();
  }
  
}

