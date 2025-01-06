import 'dart:typed_data';

import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:flutter/material.dart';

class CheckListProvider extends ChangeNotifier {

 
  List<ModelBlogData> _listFinalContent = [];
  List<ModelBlogData> get listFinalContent => _listFinalContent;


  // void setFinalContent() {

  //   _listFinalContent = listSelectedContent
  //                           .where((item) => item.selected)
  //                           .toList();
  // }

  // List<ModelBlogData> _listSelectedContent = [];

  void addContent(String name, String content, String imageUrls, Uint8List imageBytes, {bool isSelected = false, String tabularData = ''}) {
    // _listSelectedContent.add(ModelBlogData(name: name, content: content, imageUrls: imageUrls, imageBytes: imageBytes, selected: isSelected));
    _listFinalContent.add(ModelBlogData(name: name, content: content, imageUrls: imageUrls, imageBytes: imageBytes, selected: isSelected,  tabularData: tabularData));
  }

  // List<ModelBlogData> get listSelectedContent => _listSelectedContent;

  void toggleModeContentSelection(int index) {
    //_listSelectedContent[index].selected = !_listSelectedContent[index].selected;
    //notifyListeners();
  }


  

  // List<ModeContent> _listFinalContent = [];
  // List<ModeContent> get listFinalContent => _listFinalContent;


  // void setFinalContent() {

  //   _listFinalContent = listSelectedContent
  //                           .where((item) => item.selected)
  //                           .toList();
  // }

  // List<ModeContent> _listSelectedContent = [];

  // void addContent(String name, List<String> content, String imageUrls, Uint8List imageBytes) {
  //   _listSelectedContent.add(ModeContent(name: name, content: content, imageUrls: imageUrls, imageBytes: imageBytes, selected: true));
  // }

  // List<ModeContent> get listSelectedContent => _listSelectedContent;

  // void toggleModeContentSelection(int index) {
  //   _listSelectedContent[index].selected = !_listSelectedContent[index].selected;
  //   notifyListeners();
  // }



void reset() {
  _listFinalContent.clear();
  notifyListeners();
}


  
  void notify() {
    notifyListeners();
  }

  
  

}