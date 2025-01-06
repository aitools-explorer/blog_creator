import 'dart:convert';
import 'dart:typed_data';

import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Network/WebImagesHandler.dart';
import 'package:blog_creator/Network/openAIHandler.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class ReviewProvider extends ChangeNotifier {
  
  List<String> _suggestedTopics = [];
  List<String> get suggestedTopics => _suggestedTopics;
  void setSuggestedTopics(List<String> suggestedTopics) {
    _suggestedTopics = suggestedTopics.toSet().toList();
    notifyListeners();
  }

  
  String _title = 'Gandhi Ji';
  String get title => _title;

  void setTitle(String title) {
    _title = title;
    _finalTitle = title;
    notifyListeners();
  }

  String _finalTitle = '';
  String get finalTitle => _finalTitle;


  
  List<String> topics = [];

  String _selectedTopic = 'Aatma katha';
  String get selectedTopic => _selectedTopic;

  void selectTopic(String topic) {
    _selectedTopic = topic;
    _finalSelectedTopic = _selectedTopic;
    notifyListeners();
  }
  String _finalSelectedTopic = '';
  String get finalSelectedTopic => _finalSelectedTopic;



  String _selectedLanguage = 'English';
  String get selectedLanguage => _selectedLanguage;
  Future<void> updateLanguage(String language) async {
    _selectedLanguage = language;
    await convertLanguage();
    notifyListeners();
  }



  String _selectedTemplateName = 'Simple';
  String get selectedTemplateName => _selectedTemplateName;
  void updateTemplateName(String templateName) {
    _selectedTemplateName = templateName;
    notifyListeners();
  }


  final List<String> _availableTemplateNames = ['Simple', 'Simple Right', 'Simple Left', 'Alternate', 'List And Bullet Points', 'Table And Image'];
  List<String> get availableTemplateNames => _availableTemplateNames;


  List<String> get availableLanguages => _availableLanguages;
  final List<String> _availableLanguages = [
    "English",
    "Hindi",
    "Punjabi",
    "Tamil",
    "Kannada",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Arabic",
    "Russian",
  ];


  getFont() async {
    
    pw.Font font;

    switch (selectedLanguage) {
      case 'Hindi':
        font = await PdfGoogleFonts.hindLight();
        break;
      case 'Kannada':
        font = await PdfGoogleFonts.anekKannadaRegular();
        break;
      case 'Spanish':
        font = await PdfGoogleFonts.cairoRegular();
        break;
      case 'French':
        font = await PdfGoogleFonts.montserratRegular();      
        break;
      case 'German':
        font = await PdfGoogleFonts.germaniaOneRegular();      
        break;
      case 'Chinese':
        font = await PdfGoogleFonts.chivoMonoRegular();      
        break;
      case 'Arabic':
        font = await PdfGoogleFonts.notoKufiArabicRegular();      
        break;
      case 'Russian':
        font = await PdfGoogleFonts.russoOneRegular();
        break;
      case 'Punjabi':
        font = await PdfGoogleFonts.montserratRegular();
        break;
      case 'Tamil':
        font = await PdfGoogleFonts.anekTamilRegular();      
        break;
      default:
        font = await PdfGoogleFonts.notoSansAdlamRegular();
        break;
    }
    return font;
  }

  List<ModelBlogData> _listOrigContent = [];
  List<ModelBlogData> get listOrigContent => _listOrigContent;

  void setOrigContent(List<ModelBlogData> content) {
      _listOrigContent = content;
      _listFinalContent = content;
  }
  
  void clearOrigContent() {
    _listOrigContent.clear();
  }


  List<ModelBlogData> _listFinalContent = [];
  List<ModelBlogData> get listFinalContent => _listFinalContent;

  void setFinalContent(List<ModelBlogData> content) {
      _listFinalContent = content;
  }

  void clearFinalContent() {
    _listFinalContent.clear();
  }


  getFinalContent(List<ModelBlogData> finalCont) {
      
      List<dynamic> data = [];
      for (var content in finalCont) {
        data.add({
          'topic': content.name,
          'paragraph': content.content
        });
      }
      Map<String, dynamic> jsonData = {
        'title': _title,
        'topics': _selectedTopic,
        'data': data
      };

      String jsonString = jsonEncode(jsonData);

      // String _finalContent = '$_title###$_selectedTopic###';
      // for (var content in finalCont) {
      //     _finalContent += '**${content.name}**:\n${content.content}\n\n';
      // }
      return jsonString;
  }

  Future<void> convertLanguage() async {
     
      final _finalContent = getFinalContent(_listOrigContent);
      print('$_finalContent');
      print('');

      
      String response = await openAIHandler().getChatGPTResponse('Return result in same format. Translate to $_selectedLanguage : $_finalContent');
      // String response = "**गनिमी कावा युद्धतंत्र**:\nशिवाजी महाराजांना गनिमी काव्याच्या युद्धतंत्रांचे प्रभावी वापरकर्ते मानले जाते. या तंत्रामध्ये अचानक हल्ले, चढाई आणि रणनीतिक पायउतार सामील होते. \"गनिमी कावा\" म्हणून ओळखल्या जाणाऱ्या या युद्धशैलीने संख्यात्मकदृष्ट्या अधिक असलेल्या मुघल सैन्याचा प्रतिकार करण्यासाठी महत्त्वपूर्ण भूमिका बजावली.\n\n**किल्ले वास्तुकला आणि वापर**:\nकिल्ल्यांचे सामरिक महत्त्व ओळखून, शिवाजी महाराजांनी पश्‍चिम भारतात अनेक किल्ले बांधले किंवा जिंकले. त्यांनी सह्याद्री पर्वतरांगांच्या कठीण भूभागाला पूरक अशी किल्ल्यांची वास्तुकला तयार केली, जी जवळजवळ अभेद्य होती. उल्लेखनीय किल्ल्यांमध्ये रायगड, प्रतापगड, आणि सिंहगड येतात.";
      print('changed language: $response');
      print('');

      splitData(response);
  }

  Future<void> splitData(String response) async {

    List<ModelBlogData> newContent = [];

      response = response.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', '');
      
      dynamic jsonData = jsonDecode(response);
      _finalTitle = jsonData['title'];
      _finalSelectedTopic = jsonData['topics'];
      List<dynamic> data =  jsonData['data'];

      for (int i=0; i < data.length; i++) {

          String title = data[i]['topic'];
          String content = data[i]['paragraph'];
          
          if (title != null && content != null) {
              // newContent.add(title, content, '', Uint8List.fromList([],), isSelected: true );
              newContent.add(ModelBlogData(name: title, content: content, imageUrls: _listOrigContent[i].imageUrls, imageBytes: _listOrigContent[i].imageBytes, tabularData: _listOrigContent[i].tabularData, selected: true));
          }

          print('Title: ${title}  \n  Content : ${content}' );
          print('\n'); 
      } 
    setFinalContent(newContent);

  }


  

void reset() {
  _suggestedTopics.clear();
  _title = '';
  _finalTitle = '';
  topics.clear();
  _selectedTopic = '';
  _finalSelectedTopic = '';
  _selectedLanguage = 'English';
  _selectedTemplateName = 'Simple';
  _listOrigContent.clear();
  _listFinalContent.clear();
  //notifyListeners();
}

void notify() {
  notifyListeners();
}
  

}



// class ReviewProvider extends ChangeNotifier {
  
//   List<String> _suggestedTopics = [
//     'Flutter',
//     'Angular',
//     'React',
//     'Python',
//     'Dart',
//     'JavaScript',
//     'TypeScript',
//     'Kotlin',
//     'Swift',
//     'Java',
//   ];
//   List<String> get suggestedTopics => _suggestedTopics;
//   void setSuggestedTopics(List<String> suggestedTopics) {
//     _suggestedTopics = suggestedTopics.toSet().toList();
//     // notifyListeners();
//   }

  
//   String _title = '';
//   String get title => _title;

//   void setTitle(String title) {
//     _title = title;
//     notifyListeners();
//   }

  
//   List<String> topics = [];

//   String _selectedTopic = '';
//   String get selectedTopic => _selectedTopic;

//   void selectTopic(String topic) {
//     _selectedTopic = topic;
//     notifyListeners();
//   }



//   String _selectedLanguage = 'English';
//   String get selectedLanguage => _selectedLanguage;
//   Future<void> updateLanguage(String language) async {
//     _selectedLanguage = language;
//     await convertLanguage();
//     notifyListeners();
//   }



//   String _selectedTemplateName = 'Simple Right';
//   String get selectedTemplateName => _selectedTemplateName;
//   void updateTemplateName(String templateName) {
//     _selectedTemplateName = templateName;
//     notifyListeners();
//   }

//   bool _hasImage = false;
//   bool get hasImage => _hasImage;
//   void toggleHasImage() {
//       _hasImage = !_hasImage;
//       notifyListeners();
//   }


//   final List<String> _availableTemplateNames = ['Simple Right', 'Simple Left', 'Alternate', 'List And Bullet Points', 'Table And Image'];
//   List<String> get availableTemplateNames => _availableTemplateNames;


//   List<String> get availableLanguages => _availableLanguages;
//   final List<String> _availableLanguages = [
//     "English",
//     "Hindi",
//     "Spanish",
//     "French",
//     "German",
//     "Chinese",
//     "Arabic",
//     "Russian",
//     "Portuguese",
//     "Japanese",
//     "Punjabi"
//   ];

//   List<ModeContent> _listOrigContent = [];
//   List<ModeContent> get listOrigContent => _listOrigContent;

//   void setOrigContent(List<ModeContent> content) {
//       _listOrigContent = content;
//       _listFinalContent = content;
//   }


//   List<ModeContent> _listFinalContent = [];
//   List<ModeContent> get listFinalContent => _listFinalContent;

//   void setFinalContent(List<ModeContent> content) {
//       _listFinalContent = content;
//   }


//   Future<void> convertLanguage() async {
     
//       String _finalContent = '';
//       for (var content in _listOrigContent) {
//             _finalContent += '${content.name}\n${content.content.join('\n')}\n\n';
//       }
//       print('$_finalContent');
//       print('');

      
//       String response = await OpenAIProvider().getChatGPTResponse('convert to $_selectedLanguage: $_finalContent');

//       String response = "### बाजारात वेळाप्रमाणे वरदान\n1. **उच्च लाभासाठी संभावना**\nयशस्वी वेळाप्रमाणे बाजारात कमी विकत आणि उच्च विकत करून मोठे नफा कमवू शकते.\n2. **त्रास व्यवस्थापन**\nकुशल वेळा मेळवणे निवेशकांना उलटी वाळणांपुढील नुकसान सहन करण्यास मदत करू शकते.\n3. **पूँजी निर्दिष्टीकरण**\nनोंदाहीने प्रदर्शन करण्याच्या अपेक्षित असपाट्यात निवेशकांना पूँजी अधिक प्रभावीपणे निर्दिष्टित करण्याची सहाय्य करते. \n\n### वैकल्पिक रणनीती\nवेळाप्रमाणाच्या संबंधित जोखीमदार असल्याचं भिती व्यवस्थापनाच्या बाप्तांसाठी, अन्य निवेश रणनीती आहेत\n- **खरेदी आणि ठेवा**\nहा रणनीती सुरु करून त्यांना ते उच्चाकडे ठेवून धारण करणे, विपरीत बाजाराच्या समानांकडे सर्वसामान्य चळवळीतून लाभांचा उपयोग करण्यासाठी असते.\n- **डॉलर-अंकनी प्रमाण**\nनुकसानाचा परिणाम कमी करणाऱ्या उतार-चढ प्रयत्नांची तीन, उतार वेळ्यानुसार निर्यात केलेले ठरवून प्रत्येक लक्ष दिलेले धन निवेश करणे.\n- **विविधीकरण**\n धन खर्च किंवा निवेश लिहुन देण्यास खतरापूर्वक विधगतपणे विभागीत करणे.";

//       print('changed language: $response');

//       splitData(response);
//   }

//   Future<void> splitData(String response) async {

//     List<ModeContent> newContent = [];
//     List<String> blogs = response.split("\n\n");
//     for (int i=0; i< blogs.length; i++) {
        
//         String title = '';
//         List<String> content = [];
//         List<String> lines = response.split("\n");
//         for (var line in lines) {
//               print(line);
//               if (line.contains('###')) {
//                   title = line;  
//               } else {
//                   if (line.isNotEmpty) {
//                       content.add(line);  
//                   }
//               }
//         }
//         newContent.add(ModeContent(name: title, content: content, imageUrls: listFinalContent[i].imageUrls, imageBytes: listFinalContent[i].imageBytes, selected: true));
//     }
//     setFinalContent(newContent);

//   }

// }
