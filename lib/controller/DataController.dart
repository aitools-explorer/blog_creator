import 'dart:convert';
import 'dart:typed_data';

import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/ResearchDataProvider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Utils/BlogImageProvider.dart';
import 'package:blog_creator/Network/openAIHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ChartType {
  BAR,
  PIE,
  LINE,
}

class DataController {
  

    Future<List<String>> fetchSuggestedTopics() async {
        try {
            // String resp = await openAIHandler().getChatGPTResponse('suggest 10 latest topics for blog creation without extra content');
            String resp = "1. The Future of Renewable Energy Technologies\n2. Mental Health Awareness in the Digital Age\n3. The Impact of Remote Work on Corporate Culture\n4. Minimalism: Living with Less in a Consumer-Driven World\n5. Exploring the World of Plant-Based Diets\n6. Virtual Reality: Transforming Education and Training\n7. The Evolution of Social Media Marketing Strategies\n8. The Rise of Cryptocurrency: Opportunities and Challenges\n9. DIY Sustainable Home Projects for Beginners\n10. The Art of Mindfulness in a Fast-Paced World";
            await Future.delayed(const Duration(seconds: 1));
            
            List<String> topics = [];
            List<String> response = resp.split('\n');
            for (int i=0; i< response.length; i++) {
                List<String> temp = response[i].split(':');
                String name = temp.first.split('. ').last;
                topics.add(name);
                print(name);
            }
            
            return topics;
        } on Exception catch (e) {
            print('Error: $e');
            return [];
        }
    }

    Future<List<String>> fetchTitleData(String text) async {
        try {
            String resp = await openAIHandler().getChatGPTResponse('provide 10 topics points on : ${text.trim()}');
            // print('==>  $resp');
            //String resp = "Gautam Adani, the Indian billionaire and founder of the Adani Group, became rich through a combination of strategic business decisions, diversification, and capitalizing on India's economic growth. While I can't provide images, I can describe key factors and events that contributed to his wealth:\n\n1. **Founding of Adani Group**: Gautam Adani founded the Adani Group in 1988, initially dealing in agricultural commodities and later expanding into sectors such as energy, resources, logistics, agribusiness, real estate, financial services, and defense.\n\n2. **Port Development**: One of Adani's significant ventures was the development of Mundra Port in Gujarat, which has become India's largest commercial port. This strategic move into infrastructure laid the foundation for future growth and diversification.\n\n3. **Energy Sector Expansion**: Adani Group's expansion into the energy sector, including coal mining and power generation, significantly contributed to its growth. The group's investments in coal assets both domestically and internationally have played a crucial role.\n\n4. **Renewable Energy**: In recent years, the Adani Group has made significant investments in renewable energy, aligning with global trends towards sustainability. This includes solar power projects and green energy initiatives.\n\n5. **Infrastructure and Logistics**: Adani's focus on infrastructure, including airports, logistics, and transportation, has been another growth driver. The acquisition and operation of multiple airports across India have further strengthened the group's presence in the infrastructure sector.\n\n6. **Market Timing and Investments**: Adani has capitalized on strategic investments and market timing, leveraging opportunities in the Indian and global markets. This includes raising funds through public offerings and attracting investments from both domestic and international investors.\n\n7. **Government Policies and Economic Growth**: The Adani Group has benefited from favorable government policies in India, especially in sectors like infrastructure and energy. The overall economic growth of India has also played a role in the company's expansion and success.\n\n8. **Diversification**: The group's diversification into various sectors has helped mitigate risks and capitalize on multiple revenue streams, contributing to its overall wealth accumulation.\n\nThese strategic moves, along with an ability to navigate complex regulatory environments and seize emerging opportunities, have contributed to Gautam Adani's rise as one of the wealthiest individuals in the world.";
            //String resp = "Shivaji Maharaj, also known as Chhatrapati Shivaji Maharaj, was a prominent Indian warrior king and founder of the Maratha Empire in western India during the 17th century. He was born on February 19, 1630 in the hill fort of Shivneri and was crowned as the Chhatrapati (Emperor) of the Maratha Empire in 1674.\n\nShivaji Maharaj is considered as one of the greatest warriors in Indian history and is known for his military and strategic acumen, as well as his administrative abilities. He implemented innovative military tactics and strategies, such as guerrilla warfare, that helped him establish a strong and independent kingdom in the face of powerful adversaries.\n\nShivaji Maharaj was also known for his strong sense of justice and administration. He promoted religious tolerance and social welfare, and initiated various reforms for the welfare of his subjects. His reign is considered as a golden period in Maratha history, marked by prosperity, stability, and cultural revival.\n\nShivaji Maharaj's legacy continues to inspire generations of Indians, and he is revered as a national hero and icon of resistance against foreign powers. His life and achievements have been immortalized in numerous works of literature, art, and folklore, and he is widely regarded as a symbol of courage, valor, and independence.";
            // String resp = "Chhatrapati Shivaji Maharaj, the founder of the Maratha Empire in India, was a remarkable leader known for his innovative strategies, governance, and vision. Here are ten key domain points highlighting his legacy:\n\n1. **Military Innovation**: Shivaji is celebrated for his innovative military strategies, including the use of guerrilla warfare, which was particularly effective against larger Mughal and Deccan Sultanate forces.\n\n2. **Fortress Architecture**: He built and maintained numerous forts across the Western Ghats and the Konkan coast, which served as defensive strongholds and were crucial to his military operations.\n\n3. **Naval Strength**: Understanding the importance of naval power, Shivaji established a strong navy to protect the coast and assert control over the Arabian Sea, which was unprecedented for an Indian ruler of his time.\n\n4. **Ashtapradhan Council**: Shivaji established a council of eight ministers (Ashtapradhan) for efficient administration, allocating distinct roles and responsibilities to ensure a smooth governance process.\n\n5. **Religious Tolerance**: He is noted for his secular approach, respecting all religions and protecting places of worship, which helped him forge alliances across different communities.\n\n6. **Administrative Policies**: Shivaji implemented advanced administrative policies that promoted the welfare of his subjects, encouraged agriculture, supported trade, and regulated taxes.\n\n7. **Effective Intelligence Network**: He maintained an effective espionage network that provided him with vital information about his enemies' movements and plans, aiding in his military successes.\n\n8. **Promotion of Marathi**: Shivaji promoted the use of the Marathi language in administration and court matters, in place of Persian, which was prevalent in many parts of India at the time.\n\n9. **Coronation and Sovereignty**: His coronation in 1674 was a declaration of sovereignty, establishing a formal Maratha kingdom and legitimizing his rule.\n\n10. **Legacy and Inspiration**: Shivaji Maharaj's leadership, vision, and principles of governance have left a lasting legacy, inspiring future generations and movements advocating for freedom and self-rule.\n\nThese aspects of Shivaji Maharaj’s rule illustrate his multidimensional capabilities as a leader, visionary, and strategist, whose impact is still felt in Indian history and culture.";

            List<String> responses = resp.split('\n\n');
            List<String> topics = [];
            // reviewProvider.topics.clear();
            // reviewProvider.setTitle(text);

            int counter = 0;
            for (var splittedPoints in responses) {
              List<String> points = splittedPoints.split(':');
              if (points.length == 2) {
                if (counter != 0) {
                  List<String> title = points[0].trim().replaceAll('*', '').split('.');
                  topics.add(title[1]);
                }
              }
              counter++;
            }
            return topics;
        } catch (e) {
            print('Error occurred: $e');
            return [];
        }
  }

  Future<List<Modelfact>> getFacts(String domain, String topic, String prompt) async {
        
        try {

            String fPrompt = "Avoid escape notations such as \n etc, from the result. Provide 15 facts on $domain: $topic : $prompt. Result in exact format of {\"data\" : [\"1.abcd\", \"2.abcd\"]}";
            String resp = await openAIHandler().getChatGPTResponse(fPrompt);
            // String resp = "1. Shivaji Maharaj implemented the guerilla warfare technique known as \"Shiva Sutra\" or Ganimi Kava, emphasizing swift and surprise attacks.\n2. He utilized the geographical terrain of the Western Ghats to his advantage, conducting successful mountain warfare.\n3. The construction of numerous forts in strategic locations enabled him to establish strongholds and safe havens.\n4. Shivaji maintained a navy, focusing on coastal defenses and protecting maritime trade against pirates and European naval forces.\n5. He excelled in psychological warfare, spreading rumors and misinformation to confuse and demoralize his opponents.\n6. Shivaji employed a highly mobile cavalry, known for its speed and agility in hit-and-run tactics.\n7. He was adept at using intelligence networks for gathering crucial information about enemy positions and plans.\n8. The Maratha infantry played a crucial role by forming effective blockades and laying siege to enemy forts.\n9. Shivaji implemented the use of artillery strategically, making his forces well-equipped and formidable.\n10. Surprise night attacks and ambushes were common tactics in Shivaji's military campaigns.\n11. He utilized a decentralized command structure to allow rapid decision-making and adaptability in changing battlefield conditions.\n12. The Maratha military under Shivaji was noted for its disciplined and well-trained soldiers.\n13. He employed diplomatic strategies along with military prowess, often forming temporary alliances to weaken stronger opponents.\n14. Shivaji extensively leveraged the use of spies and informants to provide real-time updates and strategic advantages.\n15. His emphasis on supply chain management ensured his troops were well-provisioned, even during extended military campaigns.";
            // resp = "{\"data\" : [\"1. TCS reported a revenue of \$22.2 billion for the fiscal year 2020.\", \"2. The company witnessed a year-on-year revenue growth of 7.1% in 2020.\", \"3. TCS's net income for the year was $4.5 billion.\", \"4. The profit margin for TCS in 2020 was 20.3%.\", \"5. TCS declared a total dividend of 73 Indian Rupees per share in 2020.\", \"6. The company's operating margin for 2020 was 24.6%.\", \"7. TCS's digital revenues contributed 33.2% to the total revenue in 2020.\", \"8. The Americas remained the largest market for TCS, generating 50.8% of its 2020 revenue.\", \"9. TCS had a total workforce of over 448,000 employees in 2020.\", \"10. The attrition rate for TCS in 2020 was 12.1%.\", \"11. TCS invested heavily in research and development, with a focus on AI and automation.\", \"12. The company saw increased demand in sectors like healthcare and banking during 2020.\", \"13. TCS maintained a high rate of client retention, with many long-term engagements.\", \"14. TCS's CFO highlighted their robust balance sheet and strong cash conversion in 2020.\", \"15. The company continued to expand its global presence, with new offices and delivery centers.\"]}";

            resp = resp.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', '');;

            print('resp : ${resp}');
            List<dynamic> data =  jsonDecode(resp)['data'];

            List<Modelfact> facts = [];
            for (int i=0; i < data.length; i++) {

                String factName = data[i].toString();
                if (factName.contains('. ')) {
                    List<String> splitFact = factName.split('. ');
                    factName = splitFact.length > 1 ? splitFact[1] : '';
                }
                facts.add(Modelfact(factName:factName , isSelected: false));
            }
            return facts;
        } catch (e) {
            print(e.toString());
           return [];
        }
  }

  Future<bool> regenerate33BlogContent(BuildContext context, String facts) async {
          
          CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
          checkListProvider.listFinalContent.clear();

          try {
              String prompt = "Avoid extra spaces, escape notations such as \n etc, from the result. Provide big detail description for a blog.:";
              prompt= "Avoid extra spaces, escape notations such as \n etc, from the result. Provide big detail description for a blog. Result in format of { \"data\" : [{\"topic\": \"\", \"paragraph\": ''}, {\"topic\": '', \"paragraph\": ''}] } by occurance order on :";
              
              String resp = await openAIHandler().getChatGPTResponse('$prompt $facts');
              resp = resp.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', '');
              print('resp : ${resp}');
              List<dynamic> data =  jsonDecode(resp)['data'];

              for (int i=0; i < data.length; i++) {

                  String title = data[i]['topic'];
                  String content = data[i]['paragraph'];
                  if (title != null && content != null) {
                      checkListProvider.addContent(title, content, '', Uint8List.fromList([],), isSelected: true );
                  }

                  print('Title: ${title}  \n  Content : ${content}' );
                  print('\n'); 
              } 
              return true;
          } catch (e) {
              print(e.toString());
            return false;
          }
    }


  Future<bool> getBlogContent(BuildContext context, String facts) async {
        
        CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
        checkListProvider.listFinalContent.clear();

        try {
            String prompt= "Avoid extra spaces, escape notations such as \n etc, from the result. Provide big detail description for a blog. Result in format of { \"data\" : [{\"topic\": \"\", \"paragraph\": ''}, {\"topic\": '', \"paragraph\": ''}] } by occurance order on :";
            String resp = await openAIHandler().getChatGPTResponse('$prompt $facts');
            resp = resp.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', '');
            

            print('resp : ${resp}');
            List<dynamic> data =  jsonDecode(resp)['data'];

            

            for (int i=0; i < data.length; i++) {

                String title = data[i]['topic'];
                String content = data[i]['paragraph'];
                

                if (title != null && content != null) {
                    checkListProvider.addContent(title, content, '', Uint8List.fromList([],), isSelected: true );
                }

                print('Title: ${title}  \n  Content : ${content}' );
                print('\n'); 
            } 
            return true;
        } catch (e) {
            print(e.toString());
           return false;
        }
  }

  /// this method will regenerate block specific content
  /// it will get the topic title and content from openai
  /// and regenerate the block content
  Future<bool> addToBlockContent(BuildContext context, String title, String content) async {
    try {

      CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);

      String prompt = 'Avoid extra spaces, escape notations such as \\n etc, from the result. Provide big detail description for a blog. Result in format of { \"data\" : [{\"topic\": \"\", \"paragraph\": \'\'}}  on';
      String resp = await openAIHandler().getChatGPTResponse('${prompt} ${title.trim()} : ${content.trim()}');
      List<dynamic> data = jsonDecode(resp.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', ''))['data'];
      

      for (int j=0; j < data.length; j++) {

        String subTitle = data[j]['topic'];
        String subContent = data[j]['paragraph'];

        if (subTitle != null && subContent != null) {
          int index = checkListProvider.listFinalContent.indexWhere((element) => element.name == title);
          if (index != -1) {
            checkListProvider.listFinalContent[index] = ModelBlogData(name: subTitle, content: subContent, imageUrls: checkListProvider.listFinalContent[index].imageUrls, imageBytes: checkListProvider.listFinalContent[index].imageBytes, tabularData: checkListProvider.listFinalContent[index].tabularData, selected: true );
          } else {
            checkListProvider.addContent(subTitle, subContent, '', Uint8List.fromList([]), isSelected: true );
          }
        }
      }

      checkListProvider.notify();

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  // code for backup
  // Future<bool> regenerateBlockContent(BuildContext context, String title, String content) async {
  //   try {

  //     CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);

  //     String prompt = 'Avoid extra spaces, escape notations such as \\n etc, from the result. Provide big detail description for a blog. Result in format of { \"data\" : [{\"topic\": \"\", \"paragraph\": \'\'}}  on';
  //     String resp = await openAIHandler().getChatGPTResponse('${prompt} ${title.trim()} : ${content.trim()}');
      
  //     resp = resp.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', '');
  //     List<dynamic> data =  jsonDecode(resp)['data'];

  //     for (int i=0; i < data.length; i++) {

  //       String subTitle = data[i]['topic'];
  //       String subContent = data[i]['paragraph'];

  //       if (subTitle != null && subContent != null) {
  //         int index = checkListProvider.listFinalContent.indexWhere((element) => element.name == title);
  //         if (index != -1) {
  //           checkListProvider.listFinalContent[index] = ModelBlogData(name: subTitle, content: subContent, imageUrls: checkListProvider.listFinalContent[index].imageUrls, imageBytes: checkListProvider.listFinalContent[index].imageBytes, tabularData: checkListProvider.listFinalContent[index].tabularData, selected: true );
  //         } else {
  //           checkListProvider.addContent(subTitle, subContent, content, Uint8List.fromList([],), isSelected: false );
  //         }
  //       }
  //     }

  //     checkListProvider.notify();

  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }


Future<bool> getStatsData(BuildContext context, String prompt) async {
  try {
      String perPrompt = 'provide numerical data only with no extra text in json format:';
      String jsonData = await openAIHandler().getChatGPTResponse("${perPrompt} $prompt");
      
      // String jsonData = "```json\n{\n    \"2011\": 4500000,\n    \"2012\": 4800000,\n    \"2013\": 5100000,\n    \"2014\": 5500000,\n    \"2015\": 6000000,\n    \"2016\": 6200000,\n    \"2017\": 6500000,\n    \"2018\": 6900000,\n    \"2019\": 7300000,\n    \"2020\": 7000000,\n    \"2021\": 7500000,\n    \"2022\": 8000000\n}\n```";

      jsonData = jsonData.replaceAll('`', '').replaceAll('\\', '').replaceAll('\n', '').replaceAll('json', '');

      print('------------> $jsonData');

      // Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(jsonData));
      Map<String, dynamic> data = jsonDecode(jsonData);

      getStatImage(context, data, ChartType.BAR.name);  
     
      return true;
  } catch (e) {
    print('Error fetching image data: $e');
    return false;
  }
}


  Future<bool> getStatImage(BuildContext context, Map<String, dynamic> data, String type) async {
    try {
        String perPrompt = 'convert to quick chart url, type $type, with no extra text:';
        String prompt = '';
        
        String url = await openAIHandler().getChatGPTResponse("$perPrompt ${data.toString()}");
        
        ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);
        
        int index = researchImageProvider.modelStats.indexWhere((modelStat) => mapEquals(modelStat.stats, data));
        if (index != -1) {
          researchImageProvider.modelStats[index].url = url;
          researchImageProvider.modelStats[index].type = type;
          researchImageProvider.notifyListeners();
        } else {
          researchImageProvider.setModelStats(ModelStats(stats: data, url: url, type: type));
        }

        return true;

    } catch (e) {
      print('Error fetching image data: $e');
      return false;
    }
  }

  getDataTableData(BuildContext context, String prompt) async {

      // String perPrompt = 'Result should be in this format: {\"data\":\"tabular representation of the data\"}.Analyze the following text and provide a tabular representation of the data: $prompt';
      String perPrompt = 'Analyze the following text and provide a tabular representation of the data: $prompt';
      
      String resp = await openAIHandler().getChatGPTResponse(perPrompt);
      
      List<String> respList = resp.split('\n\n');
      
      for (String s in respList) {
        // print('-------->: $s');
        if (s.contains('```json') || s.contains('|')) {
          print('-------->: $s');
           resp = s; 
        }
      }

      resp = resp.replaceAll('`', '').replaceAll('json', '');
      ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);
      researchImageProvider.setModelTable(ModelStats(stats: {'table' : resp}, url: resp, type: 'table'));

      researchImageProvider.notify();
      
      

    
  }


}


