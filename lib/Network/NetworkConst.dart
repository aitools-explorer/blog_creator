

import 'dart:convert';
import 'dart:typed_data';

class NetworkConst {

  // open ai
  
  static const String openAiKey = 'c2stcHJvai1CUzJ0SVYtYVFKMmFCbnVWOUM3TWhFQ0tqbmpRbzY4UVZNNUoycUtIb2h2Z0xJd3JLVlgtdVRXZ003ZC1PSFRjTHFBT2dvQllUM1QzQmxia0ZKNnhyaUtCaHVkeXV3VzhWaks4Q0tncEYwS21pME5PcTJNYTRya0MzOFJPTWRpZDNlU2Vmc2lNMHViSlVTR3FqNUljZ3o1QXg2NEE=';
  static const String openAiChatUrl = 'https://api.openai.com/v1/chat/completions';
  static const String openAiImageUrl = 'https://api.openai.com/v1/images/generations';
  static const String openAiPlagiarismUrl = 'https://api.openai.com/v1/engines/text-similarity';

 // pexels
  static const String webApiKey = 'ZjY45kZSxSjvH2GWbNBKh5FN8tzYGdTqxVDs2SRtMpcp1hc2YyFa9WXr';
  static const String webApiUrl = 'https://api.pexels.com/v1/search';

  // static const String rapidApiKey = '6bff92abccmsh254afc3bc25cb76p1cbc92jsn3ac29e943e01';
  static const String rapidApiKey = '37be52ab56msh66ded5f6413f895p1e7c83jsn37a5af8334f2';
  static const String rapidApiPlagCheckUrl = 'https://plagiarism-checker-and-auto-citation-generator-multi-lingual.p.rapidapi.com/plagiarism';


//   // open ai
//   static const String openAiKey = String.fromEnvironment('openAiKey'); 
//   static const String openAiChatUrl = 'https://api.openai.com/v1/chat/completions';
//   static const String openAiImageUrl = 'https://api.openai.com/v1/images/generations';
//   static const String openAiPlagiarismUrl = 'https://api.openai.com/v1/engines/text-similarity';

//  // pexels
//   static const String webApiKey = String.fromEnvironment('webApiKey');
//   static const String webApiUrl = 'https://api.pexels.com/v1/search';

//   // static const String rapidApiKey = '6bff92abccmsh254afc3bc25cb76p1cbc92jsn3ac29e943e01';
//   static const String rapidApiKey = String.fromEnvironment('rapidApiKey');
//   static const String rapidApiPlagCheckUrl = 'https://plagiarism-checker-and-auto-citation-generator-multi-lingual.p.rapidapi.com/plagiarism';

  static String base64Decode(String input) {
  // List<int> bytes = utf8.encode(input);
  // String base64String = Base64Encoder().convert(bytes);
  
    Uint8List base64String = Base64Decoder().convert(input);
    String decoded = utf8.decode(base64String);

    return decoded;
  }


}
