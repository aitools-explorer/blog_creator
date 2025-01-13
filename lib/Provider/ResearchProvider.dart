import 'package:flutter/material.dart';

class ResearchProvider extends ChangeNotifier {

  List<String> _tabs = ['Tab 1'];
  List<String> get tabs => _tabs;
  
  
  void setTabs(List<String> tabs) {
    _tabs = tabs;
  }

  void addTab(String tab) {
    _tabs.add(tab);
    notifyListeners();
  }

  void removeTab(int index) {
    _tabs.removeAt(index);
    notifyListeners();
  }


  String _selectedTabName = '';
  String get selectedTabName => _selectedTabName;

  void setSelectedTabName(String tabName) {
    _selectedTabName = tabName;
    notifyListeners();
  }

  
  void reset() {
    _tabs = ['Tab 1'];
    _selectedTabName = '';
    notifyListeners();
  }


  void notify() {
    notifyListeners();
  }
}
