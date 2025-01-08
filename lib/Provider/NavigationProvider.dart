import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;


  void setPage(int index) {

    _pageIndex = index;
    notifyListeners();
  }

  String getTitle() {
    switch (_pageIndex) {
      case 0:
        return "Input Domain";
      case 1:
        return "Select Topic";
      case 2:
        return "Research Facts";
      case 3:
        return "Research Images";
      case 4:
        return "Authoring";
      case 5:
        return "Blog Review";
      default:
        return "";
    }
  }
}