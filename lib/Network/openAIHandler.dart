import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:blog_creator/Network/ApiClient.dart';
import 'package:blog_creator/Network/NetworkConst.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:blog_creator/Network/ApiClient.dart';
import 'package:blog_creator/Network/NetworkConst.dart';

class openAIHandler {

  
  Future<String> getChatGPTResponse(String prompt) async {
      
    final url = Uri.parse(NetworkConst.openAiChatUrl);
      
    final reqHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${NetworkConst.base64Decode(NetworkConst.openAiKey)}',
    };

    final reqBody = jsonEncode({
      // 'model': 'gpt-3.5-turbo',
      "model": "gpt-4o",
      'messages': [
        // {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': prompt},
      ],
      'temperature': 0.7,
    });

    print('request body : $reqBody');

    try {
      final response = await ApiClient().post(url.toString(), headers: reqHeaders, body: reqBody);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('API response: ${data['choices'][0]['message']['content']}');
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to load response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return 'Error fetching response';
    }
  }


  
  Future<String> getGPTImageResponse(String prompt) async {
    
    final url = Uri.parse(NetworkConst.openAiImageUrl);
    
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${NetworkConst.openAiKey}',
    };

    final body = jsonEncode({
      'prompt': prompt,
      'n': 1,
      'size': '256x256',
      'response_format': 'url',
    });

    print('API request: ${body}');

    final response = await ApiClient().post(url.toString(), headers: headers, body: body);

    if (response.statusCode == 200) {
      
      final data = jsonDecode(response.body);
      print('API response: ${data}');
      return  data['data'][0]['url'];
      
      // final imageResponse = await http.get(Uri.parse(imageUrl));
      // if (imageResponse.statusCode == 200) {
      //   return imageResponse.bodyBytes;
      // } else {
      //   return Uint8List.fromList([]);
      // }
    } else {
      return '';
    }
  }



}
