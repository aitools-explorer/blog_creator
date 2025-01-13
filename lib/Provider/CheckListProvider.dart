import 'dart:typed_data';

import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:flutter/material.dart';

class CheckListProvider extends ChangeNotifier {

  List<ModelBlogData> _listFinalContent = [];
  List<ModelBlogData> get listFinalContent => _listFinalContent;

  void setFinalContent(List<ModelBlogData> content) {
    _listFinalContent = content;
  }

  void addContent(String name, String content, String imageUrls, Uint8List imageBytes, {bool isSelected = false, String tabularData = ''}) {
    _listFinalContent.add(ModelBlogData(name: name, content: content, imageUrls: imageUrls, imageBytes: imageBytes, selected: isSelected, tabularData: tabularData));
  }

  void toggleModeContentSelection(int index) {
    if (index >= 0 && index < _listFinalContent.length) {
      _listFinalContent[index].selected = !_listFinalContent[index].selected;
      notifyListeners();
    }
  }

  void reset() {
    _listFinalContent.clear();
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
