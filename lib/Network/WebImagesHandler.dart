
import 'package:blog_creator/Network/ApiClient.dart';
import 'package:blog_creator/Network/NetworkConst.dart';
import 'dart:convert';

class WebImagesHandler {
  
  Future<String> getPhotos(String query) async {
    
    final headers = {
      'Authorization': NetworkConst.base64Decode(NetworkConst.webApiKey)
    };
    
    final response = await ApiClient().get('${NetworkConst.webApiUrl}?query=$query&per_page=1&page=1',  headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final jsonData = jsonDecode(responseBody);
      print('jsonData: $jsonData');
      
      String photos = jsonData['photos'][0]['src']['medium'];

      print('Photos: $photos');

      return photos; // Assuming you want to return the photos list directly
    } else {
      throw Exception('Failed to load photos');
    }
    
  }

  Future<List<String>> getPhotosList(String query) async {
    
    final headers = {
      'Authorization': NetworkConst.base64Decode(NetworkConst.webApiKey)
    };
    
    final response = await ApiClient().get('${NetworkConst.webApiUrl}?query=$query&per_page=6&page=1',  headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final jsonData = jsonDecode(responseBody);

      List<String> photosList = [];
      for (var photo in jsonData['photos']) {
        photosList.add(photo['src']['medium']);
      }

      print('Photos: $photosList');

      return photosList; // Assuming you want a comma-separated string of photo URLs
    } else {
      throw Exception('Failed to load photos');
    }
    
  }
  
}
