import 'dart:convert';

import 'package:blog_creator/Network/NetworkConst.dart';

import 'package:blog_creator/Network/ApiClient.dart';

class RapidApiHandler {
  

  Future<int> getPlagiarismCheck(String text) async {


      final _headers = {
        'Content-Type': 'application/json',
        'x-rapidapi-host': 'plagiarism-checker-and-auto-citation-generator-multi-lingual.p.rapidapi.com',
        'x-rapidapi-key': NetworkConst.rapidApiKey
      };
    

      final _body = jsonEncode({
        'text': text,
        'language': 'en',
        'includeCitations': false,
        'scrapeSources': false
      });

      print('getPlagiarismCheck Body: $_body');

      try {
        final response = await ApiClient().post(NetworkConst.rapidApiPlagCheckUrl, headers: _headers, body: _body);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          //{"sources":[],"percentPlagiarism":0}
          print('getPlagiarismCheck Response: $data');
          return data['percentPlagiarism'].toInt();
          
        } else {
          throw Exception('Failed to load response: ${response.statusCode}');
        }
      } on Exception catch (e) {
        print('getPlagiarismCheck Error: $e');
        throw Exception('Failed to load response');
      }
  }
}

