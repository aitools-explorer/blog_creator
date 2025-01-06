import 'dart:typed_data';

class ModeContent {
  String name;
  String imageUrls;
  Uint8List imageBytes;
  List<String> content;
  bool selected;

  ModeContent({required this.name, required this.content, required this.imageUrls, required this.imageBytes, required this.selected});

  @override
  String toString() {
    return 'ModeContent{name: $name, content: $content, imageUrls: $imageUrls, imageBytes: $imageBytes, selected: $selected}';
  }
}
