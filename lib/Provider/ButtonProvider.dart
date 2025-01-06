import 'package:flutter/material.dart';

class ButtonProvider with ChangeNotifier {
  
  // Button labels and icons
  final List<Map<String, dynamic>> buttonData = [
    {'label': 'Stock Images', 'icon': Icons.image},
    {'label': 'AI Images', 'icon': Icons.smart_toy},
    {'label': 'Graphs', 'icon': Icons.bar_chart},
    {'label': 'Tables', 'icon': Icons.table_chart},
  ];
  
  int _selectedButtonIndex = 0;

  int get selectedButtonIndex => _selectedButtonIndex;

  void selectButton(int index) {
    _selectedButtonIndex = index;
    notifyListeners();
  }
}
