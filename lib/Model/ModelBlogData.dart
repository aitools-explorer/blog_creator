

import 'dart:typed_data';

class ModelBlogData {
  String name;
  String imageUrls;
  Uint8List imageBytes;
  String content;
  bool selected;
  String tabularData;

  ModelBlogData({
    required this.name,
    required this.imageUrls,
    required this.imageBytes,
    required this.content,
    required this.selected,
    required this.tabularData,
  });

  @override
  String toString() {
    return 'ModelBlogData(name: $name, imageUrls: $imageUrls, imageBytes: ${imageBytes.length} bytes, content: $content, selected: $selected, tabularData: $tabularData)';
  }
}
