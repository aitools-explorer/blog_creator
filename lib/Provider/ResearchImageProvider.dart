import 'package:flutter/material.dart';

class ModelImage {
  final String imageUrl;
  bool isSelected;

  ModelImage({required this.imageUrl, this.isSelected = false});

  
  factory ModelImage.fromJson(Map<String, dynamic> json) {
    return ModelImage(
      imageUrl: json['imageUrl'],
      isSelected: json['isSelected'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'isSelected': isSelected,
    };
  }
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

  static Future<ModelStats> fromJson(Map<String, dynamic> json) async {
    return ModelStats(
      stats: json['stats'],
      url: json['url'],
      type: json['type'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'stats': stats,
      'url': url,
      'type': type,
      'isSelected': isSelected,
    };
  }
}

class ResearchImageProvider with ChangeNotifier {


  List<String> _selectedImages = [];
  List<ModelImage> _webImages = [];
  List<ModelImage> _aiImages = [];
  List<ModelStats> _modelStats = [];
  List<ModelStats> _modelTable = [];


  void setWebImages(List<String> imageUrls) {
    _webImages = imageUrls.map((url) => ModelImage(imageUrl: url)).toList();
    notifyListeners();
  }

  void setWebImagesModel(List<ModelImage> images) {
    _webImages = images;
    notifyListeners();
  }
  
  void setAIImages(List<String> imageUrls) {
    _aiImages = imageUrls.map((url) => ModelImage(imageUrl: url)).toList();
    notifyListeners();
  }

  void setAIImagesModel(List<ModelImage> images) {
    _aiImages = images;
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





void setSelectedImages(List<String> imageUrls) {
  _selectedImages = imageUrls;
  notifyListeners();
}

List<String> get selectedImages => _selectedImages;


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

  void notify() {
    notifyListeners();
  }


void setModelStats(ModelStats modelStats) {
    _modelStats.add(modelStats);
    notifyListeners();
}

void setModelStatsList(List<ModelStats> modelStatsList) {
    _modelStats = modelStatsList;
    notifyListeners();
}

List<ModelStats> get modelStats => _modelStats;

void toggleModelStatsSelection(int index) {
  if (index >= 0 && index < _modelStats.length) {
    _modelStats[index].isSelected = !_modelStats[index].isSelected;
    notifyListeners();
  }
}

  

  List<ModelStats> get modelTable => _modelTable;

  void setModelTable(ModelStats modelStats) {
    _modelTable.add(modelStats);
    notifyListeners();
  }

  void setModelTableList(List<ModelStats> modelStatsList) {
    _modelTable = modelStatsList;
  }

  void toggleModelTableSelection(int index) {
    if (index >= 0 && index < _modelTable.length) {
      _modelTable[index].isSelected = !_modelTable[index].isSelected;
      notifyListeners();
    }
  }

  

  void reset() {
    
    _selectedImages.clear();
    _webImages.clear();
    _aiImages.clear();
    _modelStats.clear();
    _modelTable.clear();
    notifyListeners();
  }

}
