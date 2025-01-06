import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class RapidAiImageProvider {
  

  Future<List<String>> getAIImage(String prompt) async {
        final url = Uri.parse('https://ai-image-generator3.p.rapidapi.com/generate');
        
        final headers = {
          'Content-Type': 'application/json',
          'x-rapidapi-host': 'ai-image-generator3.p.rapidapi.com',
          'x-rapidapi-key': '6bff92abccmsh254afc3bc25cb76p1cbc92jsn3ac29e943e01',
        };

        final body = jsonEncode({
          'prompt': prompt,
          'page': 1,
        });

        try {
            final response = await http.post(url, headers: headers, body: body);
            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              print('Ai images: $data');

              // var results = data['results']['variaties'][0]['urls'][0];
              
              // if (data['results']['variaties'].isNotEmpty) {
              //     for (var variaty in data['results']['variaties']) {
              //         results.addAll(List<String>.from(variaty['urls']));
              //     }
              // }

              List<String> results = [];
              for (var url in data['results']['variaties'][0]['urls']) {
                  results.add(url);
              }
              
              print('\nAi images: $results');
              return results;
            } else {
              throw Exception('Failed to load AI images ${response.statusCode}  ${response.body}');
            }
        } on Exception catch (e) {
            print('Error: $e');
            throw Exception('Failed to load AI images');
        }
  }

  
}
