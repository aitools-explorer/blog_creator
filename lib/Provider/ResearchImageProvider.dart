import 'package:flutter/material.dart';

class ModelImage {
  final String imageUrl;
  bool isSelected;

  ModelImage({required this.imageUrl, this.isSelected = false});
}

class ModelStats {
  final Map<String, dynamic> stats;
  String url;
  String type;
  bool isSelected;

  ModelStats({
    required this.stats,
    required this.url,
    required this.type,
    this.isSelected = false,
  });
}

class ResearchImageProvider with ChangeNotifier {


  List<ModelImage> _webImages = [];
  List<ModelImage> _aiImages = [];

  void setWebImages(List<String> imageUrls) {
    _webImages = imageUrls.map((url) => ModelImage(imageUrl: url)).toList();
    notifyListeners();
  }

  void setAIImages(List<String> imageUrls) {
    _aiImages = imageUrls.map((url) => ModelImage(imageUrl: url)).toList();
    notifyListeners();
  }

  List<ModelImage> get webImages => _webImages;
  List<ModelImage> get aiImages => _aiImages;


  void toggleAiImageSelection(String imageUrl) {
    for (var image in _aiImages) {
      if (image.imageUrl == imageUrl) {
        image.isSelected = !image.isSelected;
        break;
      }
    }
    notifyListeners();
  }

  void toggleWebImageSelection(String imageUrl) {
    for (var image in _webImages) {
      if (image.imageUrl == imageUrl) {
        image.isSelected = !image.isSelected;
        break;
      }
    }
  }



  List<String> _selectedImages = [];

  void addImageFromSelectedList(String url) {
    if (!_selectedImages.contains(url)) {
      _selectedImages.add(url);
    }
    notifyListeners();
  }

  void removeImageFromSelectedList(String url) {
    if (_selectedImages.contains(url)) {
      _selectedImages.remove(url);
    }
    notifyListeners();
  }

  List<String> get selectedImages => _selectedImages;

  void notify() {
    notifyListeners();
  }




List<ModelStats> _modelStats = [];

void setModelStats(ModelStats modelStats) {
    _modelStats.add(modelStats);
    notifyListeners();
}

List<ModelStats> get modelStats => _modelStats;

void toggleModelStatsSelection(int index) {
  if (index >= 0 && index < _modelStats.length) {
    _modelStats[index].isSelected = !_modelStats[index].isSelected;
    notifyListeners();
  }
}

  List<ModelStats> _modelTable = [];

  List<ModelStats> get modelTable => _modelTable;

  void setModelTable(ModelStats modelStats) {
    _modelTable.add(modelStats);
    notifyListeners();
  }

  void toggleModelTableSelection(int index) {
    if (index >= 0 && index < _modelTable.length) {
      _modelTable[index].isSelected = !_modelTable[index].isSelected;
      notifyListeners();
    }
  }

  

  void reset() {
    _modelStats.clear();
    _selectedImages.clear();
    _webImages.forEach((element) => element.isSelected = false);
    _aiImages.forEach((element) => element.isSelected = false);
    notifyListeners();
  }








}
