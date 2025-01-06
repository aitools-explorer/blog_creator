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
  

    Future<bool> fetchSuggestedTopics(BuildContext context) async {
        try {
            String resp = await openAIHandler().getChatGPTResponse('suggest 10 latest topics for blog creation without extra content');
            //  String resp = "1. The Future of Renewable Energy Technologies\n2. Mental Health Awareness in the Digital Age\n3. The Impact of Remote Work on Corporate Culture\n4. Minimalism: Living with Less in a Consumer-Driven World\n5. Exploring the World of Plant-Based Diets\n6. Virtual Reality: Transforming Education and Training\n7. The Evolution of Social Media Marketing Strategies\n8. The Rise of Cryptocurrency: Opportunities and Challenges\n9. DIY Sustainable Home Projects for Beginners\n10. The Art of Mindfulness in a Fast-Paced World";
             
            
            List<String> topics = [];
            List<String> response = resp.split('\n');
            for (int i=0; i< response.length; i++) {
                List<String> temp = response[i].split(':');
                String name = temp.first.split('. ').last;
                topics.add(name);
                print(name);
            }
            
            Provider.of<ReviewProvider>(context, listen: false).setSuggestedTopics(topics);
            return true;
        } on Exception catch (e) {
            print('Error: $e');
            return false;
        }
    }

    Future<bool> fetchTitleData(BuildContext context, String text) async {
        try {
            String resp = await openAIHandler().getChatGPTResponse('provide 10 topics points on : ${text.trim()}');
            // print('==>  $resp');
            //String resp = "Gautam Adani, the Indian billionaire and founder of the Adani Group, became rich through a combination of strategic business decisions, diversification, and capitalizing on India's economic growth. While I can't provide images, I can describe key factors and events that contributed to his wealth:\n\n1. **Founding of Adani Group**: Gautam Adani founded the Adani Group in 1988, initially dealing in agricultural commodities and later expanding into sectors such as energy, resources, logistics, agribusiness, real estate, financial services, and defense.\n\n2. **Port Development**: One of Adani's significant ventures was the development of Mundra Port in Gujarat, which has become India's largest commercial port. This strategic move into infrastructure laid the foundation for future growth and diversification.\n\n3. **Energy Sector Expansion**: Adani Group's expansion into the energy sector, including coal mining and power generation, significantly contributed to its growth. The group's investments in coal assets both domestically and internationally have played a crucial role.\n\n4. **Renewable Energy**: In recent years, the Adani Group has made significant investments in renewable energy, aligning with global trends towards sustainability. This includes solar power projects and green energy initiatives.\n\n5. **Infrastructure and Logistics**: Adani's focus on infrastructure, including airports, logistics, and transportation, has been another growth driver. The acquisition and operation of multiple airports across India have further strengthened the group's presence in the infrastructure sector.\n\n6. **Market Timing and Investments**: Adani has capitalized on strategic investments and market timing, leveraging opportunities in the Indian and global markets. This includes raising funds through public offerings and attracting investments from both domestic and international investors.\n\n7. **Government Policies and Economic Growth**: The Adani Group has benefited from favorable government policies in India, especially in sectors like infrastructure and energy. The overall economic growth of India has also played a role in the company's expansion and success.\n\n8. **Diversification**: The group's diversification into various sectors has helped mitigate risks and capitalize on multiple revenue streams, contributing to its overall wealth accumulation.\n\nThese strategic moves, along with an ability to navigate complex regulatory environments and seize emerging opportunities, have contributed to Gautam Adani's rise as one of the wealthiest individuals in the world.";
            //String resp = "Shivaji Maharaj, also known as Chhatrapati Shivaji Maharaj, was a prominent Indian warrior king and founder of the Maratha Empire in western India during the 17th century. He was born on February 19, 1630 in the hill fort of Shivneri and was crowned as the Chhatrapati (Emperor) of the Maratha Empire in 1674.\n\nShivaji Maharaj is considered as one of the greatest warriors in Indian history and is known for his military and strategic acumen, as well as his administrative abilities. He implemented innovative military tactics and strategies, such as guerrilla warfare, that helped him establish a strong and independent kingdom in the face of powerful adversaries.\n\nShivaji Maharaj was also known for his strong sense of justice and administration. He promoted religious tolerance and social welfare, and initiated various reforms for the welfare of his subjects. His reign is considered as a golden period in Maratha history, marked by prosperity, stability, and cultural revival.\n\nShivaji Maharaj's legacy continues to inspire generations of Indians, and he is revered as a national hero and icon of resistance against foreign powers. His life and achievements have been immortalized in numerous works of literature, art, and folklore, and he is widely regarded as a symbol of courage, valor, and independence.";
            // String resp = "Chhatrapati Shivaji Maharaj, the founder of the Maratha Empire in India, was a remarkable leader known for his innovative strategies, governance, and vision. Here are ten key domain points highlighting his legacy:\n\n1. **Military Innovation**: Shivaji is celebrated for his innovative military strategies, including the use of guerrilla warfare, which was particularly effective against larger Mughal and Deccan Sultanate forces.\n\n2. **Fortress Architecture**: He built and maintained numerous forts across the Western Ghats and the Konkan coast, which served as defensive strongholds and were crucial to his military operations.\n\n3. **Naval Strength**: Understanding the importance of naval power, Shivaji established a strong navy to protect the coast and assert control over the Arabian Sea, which was unprecedented for an Indian ruler of his time.\n\n4. **Ashtapradhan Council**: Shivaji established a council of eight ministers (Ashtapradhan) for efficient administration, allocating distinct roles and responsibilities to ensure a smooth governance process.\n\n5. **Religious Tolerance**: He is noted for his secular approach, respecting all religions and protecting places of worship, which helped him forge alliances across different communities.\n\n6. **Administrative Policies**: Shivaji implemented advanced administrative policies that promoted the welfare of his subjects, encouraged agriculture, supported trade, and regulated taxes.\n\n7. **Effective Intelligence Network**: He maintained an effective espionage network that provided him with vital information about his enemies' movements and plans, aiding in his military successes.\n\n8. **Promotion of Marathi**: Shivaji promoted the use of the Marathi language in administration and court matters, in place of Persian, which was prevalent in many parts of India at the time.\n\n9. **Coronation and Sovereignty**: His coronation in 1674 was a declaration of sovereignty, establishing a formal Maratha kingdom and legitimizing his rule.\n\n10. **Legacy and Inspiration**: Shivaji Maharaj's leadership, vision, and principles of governance have left a lasting legacy, inspiring future generations and movements advocating for freedom and self-rule.\n\nThese aspects of Shivaji Maharaj’s rule illustrate his multidimensional capabilities as a leader, visionary, and strategist, whose impact is still felt in Indian history and culture.";

            List<String> responses = resp.split('\n\n');
            ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
            // reviewProvider.topics.clear();
            // reviewProvider.setTitle(text);

            int counter = 0;
            for (var splittedPoints in responses) {
              List<String> points = splittedPoints.split(':');
              if (points.length == 2) {
                if (counter != 0) {
                  List<String> title = points[0].trim().replaceAll('*', '').split('.');
                  reviewProvider.topics.add(title[1]);
                }
              }
              counter++;
            }
            return true;
        } catch (e) {
            print('Error occurred: $e');
            return false;
        }
  }

  Future<bool> getFacts(BuildContext context, String tabName, String domain, String topic, String prompt) async {
        
        ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);
        try {

            // domain = 'Gandhi ji';
            String fPrompt = "Avoid escape notations such as \n etc, from the result. Provide 15 facts on $domain: $topic : $prompt. Result in exact format of {\"data\" : [\"1.abcd\", \"2.abcd\"]}";
            String resp = await openAIHandler().getChatGPTResponse(fPrompt);
            // resp = 
            // String resp = await openAIHandler().getChatGPTResponse('provide 15 facts in number points and no extra content on:- $domain: $topic');
            //String resp = "1. **Guerrilla Warfare**: Shivaji Maharaj is renowned for employing guerrilla warfare tactics, utilizing the geography of the Western Ghats to conduct swift and surprise attacks against larger, traditional forces.\n\n2. **Fortress Control**: He strategically constructed and captured forts, having a network of over 300 forts. This provided strong defensive positions and control over key trade routes.\n\n3. **Navy Establishment**: Shivaji established a formidable naval presence along the Konkan coast to protect against coastal raids and facilitate trade, making him one of the few Indian kings to focus on naval strength.\n\n4. **Intelligence and Spies**: He maintained a robust intelligence network to gather crucial information on enemy movements and strategies, which was integral to his planning and execution of military operations.\n\n5. **Rapid Troop Movement**: Utilized light cavalry and infantry, capable of rapid movement across difficult terrains, to execute surprise raids and retreats swiftly.\n\n6. **Innovative Tactics**: Employed innovative tactics like the strategic fortification of hilltops and the use of mobile artillery, enhancing the effectiveness of his defenses and siege capabilities.\n\n7. **Diplomacy and Alliances**: Used diplomatic channels to forge alliances with local rulers and keep the Mughal Empire and other rivals embroiled in multiple conflicts, ensuring no single front against his dominion.\n\n8. **Decentralized Command**: Delegated significant authority to trusted lieutenants and local chieftains, allowing for flexible and quick decision-making in various regions.\n\n9. **Controlled Military Growth**: Focused on developing a well-trained, disciplined, and loyal army rather than maintaining large numbers, prioritizing quality over quantity.\n\n10. **Punitive Expeditions**: Conducted punitive expeditions to deter hostile neighbors and renegades, ensuring minimal dissent and reinforcing his authority in contested regions.\n\nThese strategies collectively contributed to Shivaji Maharaj's reputation as a brilliant military leader and enabled the establishment and expansion of the Maratha Empire.";
            // String resp = "1. Shivaji Maharaj implemented the guerilla warfare technique known as \"Shiva Sutra\" or Ganimi Kava, emphasizing swift and surprise attacks.\n2. He utilized the geographical terrain of the Western Ghats to his advantage, conducting successful mountain warfare.\n3. The construction of numerous forts in strategic locations enabled him to establish strongholds and safe havens.\n4. Shivaji maintained a navy, focusing on coastal defenses and protecting maritime trade against pirates and European naval forces.\n5. He excelled in psychological warfare, spreading rumors and misinformation to confuse and demoralize his opponents.\n6. Shivaji employed a highly mobile cavalry, known for its speed and agility in hit-and-run tactics.\n7. He was adept at using intelligence networks for gathering crucial information about enemy positions and plans.\n8. The Maratha infantry played a crucial role by forming effective blockades and laying siege to enemy forts.\n9. Shivaji implemented the use of artillery strategically, making his forces well-equipped and formidable.\n10. Surprise night attacks and ambushes were common tactics in Shivaji's military campaigns.\n11. He utilized a decentralized command structure to allow rapid decision-making and adaptability in changing battlefield conditions.\n12. The Maratha military under Shivaji was noted for its disciplined and well-trained soldiers.\n13. He employed diplomatic strategies along with military prowess, often forming temporary alliances to weaken stronger opponents.\n14. Shivaji extensively leveraged the use of spies and informants to provide real-time updates and strategic advantages.\n15. His emphasis on supply chain management ensured his troops were well-provisioned, even during extended military campaigns.";
            // resp = "{\"data\" : [\"1. TCS reported a revenue of \$22.2 billion for the fiscal year 2020.\", \"2. The company witnessed a year-on-year revenue growth of 7.1% in 2020.\", \"3. TCS's net income for the year was $4.5 billion.\", \"4. The profit margin for TCS in 2020 was 20.3%.\", \"5. TCS declared a total dividend of 73 Indian Rupees per share in 2020.\", \"6. The company's operating margin for 2020 was 24.6%.\", \"7. TCS's digital revenues contributed 33.2% to the total revenue in 2020.\", \"8. The Americas remained the largest market for TCS, generating 50.8% of its 2020 revenue.\", \"9. TCS had a total workforce of over 448,000 employees in 2020.\", \"10. The attrition rate for TCS in 2020 was 12.1%.\", \"11. TCS invested heavily in research and development, with a focus on AI and automation.\", \"12. The company saw increased demand in sectors like healthcare and banking during 2020.\", \"13. TCS maintained a high rate of client retention, with many long-term engagements.\", \"14. TCS's CFO highlighted their robust balance sheet and strong cash conversion in 2020.\", \"15. The company continued to expand its global presence, with new offices and delivery centers.\"]}";

            resp = resp.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', '');;

            print('resp : ${resp}');
            List<dynamic> data =  jsonDecode(resp)['data'];

            for (int i=0; i < data.length; i++) {

                String factName = data[i].toString();
                if (factName.contains('. ')) {
                    List<String> splitFact = factName.split('. ');
                    factName = splitFact.length > 1 ? splitFact[1] : '';
                }
                researchDataProvider.add(tabName, Modelfact(factName:factName , isSelected: false));
            }

            // List<String> responses = resp.split('\n\n');

            // String title='';
            // String content = '';

            // List<String> facts = resp.split('\n');

            // for (int i=0; i < facts.length; i++) {
                
            //     List<String> indvFact = facts[i].split('. ');
                
            //     if (indvFact.isNotEmpty) {
            //         content = indvFact[1].trim().replaceAll('*', '').replaceAll('#', '');
            //         if (content.isNotEmpty) {
            //             researchDataProvider.add(tabName, Modelfact(factName: content, isSelected: false));
            //         }
            //     }
            //     title = '';
            //     content = '';
            //     //print('Title: ${title}  \n  Content : ${content}' );
            //     // print('\n');
                  
            // }
            researchDataProvider.notify();
            
            return true;
        } catch (e) {
            print(e.toString());
           return false;
        }
  }

Future<bool> getTopicDetails(BuildContext context, String blogTitle, String blogTopic) async {
        
        CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
        try {
              
            
            String resp = await openAIHandler().getChatGPTResponse('Provide facts in points on : $blogTitle: $blogTopic');
            // String resp = "Mahatma Gandhi's influence worldwide is profound and extends far beyond his role in India's struggle for independence. Here are some key areas where Gandhi's impact is evident:\n\n1. **Nonviolent Resistance (Satyagraha):** Gandhi's philosophy of nonviolent resistance has inspired countless movements and leaders around the world. His belief in \"satyagraha\" (truth force) and non-cooperation as powerful tools for social and political change have been adopted by various movements striving for justice and equality.\n\n2. **Civil Rights Movement:** In the United States, Martin Luther King Jr. was profoundly influenced by Gandhi's methods. King adopted nonviolent resistance as the core strategy of the Civil Rights Movement, which played a crucial role in ending segregation and securing equal rights for African Americans.\n\n3. **Anti-Apartheid Movement:** Nelson Mandela and other leaders in South Africa drew inspiration from Gandhi's principles in their struggle against apartheid. Gandhi's early activism in South Africa against racial discrimination laid a strong foundation for the anti-apartheid movement.\n\n4. **Freedom and Independence Movements:** Many leaders across Asia, Africa, and Latin America, including figures like Aung San Suu Kyi in Myanmar and Steve Biko in South Africa, have looked to Gandhi's strategies in their own fights for freedom and national independence from colonial rule.\n\n5. **Environmentalism and Simplicity:** Gandhi's emphasis on simple living, self-sufficiency, and respect for nature resonates with modern environmental movements. His advocacy for sustainable and community-oriented living has influenced contemporary ecological and sustainability initiatives.\n\n6. **Human Rights and Peace:** Organizations and individuals advocating for human rights and peacebuilding have adopted Gandhi's ideals. His messages of love, compassion, and understanding have been fundamental to peace negotiations and reconciliation efforts worldwide.\n\n7. **Educational and Social Reform:** Gandhi's focus on the upliftment of marginalized communities, including the betterment of rural education and the empowerment of women and lower castes, has had a lasting impact on social reform policies in various countries.\n\n8. **Cultural Legacy:** Gandhi's life and teachings continue to be studied and celebrated in academic institutions and cultural mediums worldwide. His legacy is preserved through literature, films, and memorials, inspiring future generations to explore nonviolent approaches to conflict resolution.\n\nOverall, Gandhi's influence is a testament to the power of nonviolence, truth, and moral integrity in addressing and overcoming social and political challenges. His ideals remain relevant in contemporary discourse on justice, equality, and sustainable living.";
            //String resp = "Chhatrapati Shivaji Maharaj, the founder of the Maratha Empire in western India, is renowned for his military strategies and innovations that significantly contributed to his success in establishing and consolidating his kingdom in the 17th century. Here are some of his notable military innovations:\n\n1. **Guerrilla Warfare**: Shivaji is often credited with pioneering guerilla warfare in the Indian subcontinent. His tactics included swift raids, ambushes, and hit-and-run tactics, which allowed his smaller forces to effectively combat much larger armies.\n\n2. **Fortress Building and Utilization**: Recognizing the strategic importance of geography, Shivaji built and maintained a network of forts across his territory. Each fort was strategically located for defense, supply management, and communication. Forts like Raigad, Pratapgad, and Sindhudurg became key centers of his military power.\n\n3. **Naval Force**: Acknowledging the importance of securing coastlines, Shivaji developed a formidable naval force. He built ships of various sizes and enhanced coastal defense capabilities, allowing him to protect vital maritime trade routes from pirates and foreign powers.\n\n4. **Military Organization**: Shivaji reorganized his army into a disciplined and well-structured force with specific roles, such as cavalry (known for the Maratha light cavalry), infantry, and artillery units. His emphasis on training and agility gave his forces a distinct edge.\n\n5. **Asymmetric Warfare**: Rather than confronting large Mughal armies head-on, Shivaji employed asymmetric warfare tactics, choosing battle conditions favorably, and exploiting his enemies' weaknesses.\n\n6. **Intelligence Network**: Shivaji established a vast and effective network of spies and informants, which provided him with timely information about enemy movements, plans, and internal conditions. This intelligence was crucial for planning his military campaigns.\n\n7. **Logistics and Mobility**: Emphasizing speed and mobility, Shivaji ensured his troops could move quickly and efficiently. His logistical strategies included using local resources to sustain his army without relying on extended supply lines.\n\n8. **Cultural and Psychological Warfare**: Understanding the power of motivation, Shivaji fostered a sense of unity and nationalism among his troops, often leveraging cultural, religious, and regional identities to inspire and unite his soldiers under his leadership.\n\nThrough these and other strategies, Shivaji Maharaj was able to build a resilient and adaptable military force that successfully challenged much larger empires and laid the foundation for Maratha dominance in the region. His military acumen continues to be studied and admired in military history.";
            // String resp = "Chhatrapati Shivaji Maharaj was a pioneering Maratha leader and warrior who significantly transformed warfare in 17th-century India through innovative military strategies and tactics. His contributions played a crucial role in establishing the Maratha Empire and resisting Mughal dominance. Here are several key points highlighting his military innovations:\n\n1. **Guerrilla Warfare Tactics**: Shivaji Maharaj is often credited with effectively employing guerrilla warfare techniques, which involved hit-and-run attacks, surprise raids, and strategic retreats. This style of warfare, known as “Ganimi Kava,” was instrumental in countering the numerically superior Mughal forces.\n\n2. **Fort Architecture and Utilization**: Recognizing the strategic importance of forts, Shivaji either built or captured numerous forts across Western India. He focused on fort architecture that complemented the rugged terrain of the Sahyadri Mountains, making them nearly impregnable. Notable forts include Raigad, Pratapgad, and Sinhagad.\n\n3. **Navy Development**: Shivaji established a formidable navy to protect the Konkan coastline and safeguard vital trade routes. His naval forces, comprised of small, agile ships, successfully challenged the dominance of the Portuguese, Siddis, and British on the western coast of India.\n\n4. **Strategic Alliances and Diplomacy**: Shivaji achieved strategic triumphs not just through military might but also through astute diplomacy. He forged alliances with local chieftains and utilized complex diplomacy to neutralize adversaries when direct military confrontation was not feasible.\n\n5. **Intelligence Network**: An efficient intelligence network was established to gather timely information regarding enemy movements and plans. This system ensured that Shivaji could anticipate and counteract enemy strategies effectively.\n\n6. **Asymmetric Warfare**: He employed asymmetric warfare methods, leveraging the speed and mobility of his forces. His army was trained to adapt to different combat scenarios, which allowed them to exploit enemy weaknesses.\n\n7. **Effective Use of Cavalry**: Shivaji’s army was known for its swift cavalry units, which could penetrate deep into enemy territory and disrupt their formations and supply lines. This mobility gave Shivaji a significant advantage in various campaigns.\n\n8. **Administrative and Military Reforms**: Shivaji reformed the military administration by implementing a merit-based system for promotions, thereby reducing corruption and ensuring competence within the ranks. His Ashtapradhan Mandal (Council of Eight Ministers) streamlined military and state functions.\n\n9. **Logistics and Supply Management**: Emphasizing the importance of logistics, Shivaji established systems to ensure reliable supply lines for his troops. His planning and resource management sustained his armies during protracted campaigns.\n\n10. **Cultural and Psychological Warfare**: Shivaji understood the psychological aspects of warfare. By projecting a strong, heroic image, he inspired his troops and demoralized his enemies, crafting a narrative of resilience and defiance against the Mughals.\n\nChhatrapati Shivaji Maharaj’s military innovations left a lasting legacy on Indian warfare. His combination of strategic acumen, tactical flexibility, and administrative reforms established a foundation for the Maratha Empire's resistance to external powers and underscored his reputation as a visionary leader and brilliant military strategist.";
            
          
            
            // if (responses.length > 0) {
            //     checkListProvider.setTitle(responses[0].trim());
            // }
            List<String> responses = resp.split('\n\n');

            String title='';
            String content = '';

            for (int i=0; i < responses.length; i++) {
                  
                  var splittedTitlePoints = responses[i];
                  // print('-> $splittedTitlePoints'  );
                  // print('\n');
                  final regex = RegExp(r'^[^a-zA-Z0-9]');
                  
                  if (i ==0 || i == responses.length-1 && !regex.hasMatch(splittedTitlePoints)) {
                    // if first and last index and The line does not starts with a special character
                    if (i == 0) {
                      title = 'Introduction';
                    } else if (i == responses.length - 1) {
                      title = 'Conclusion';
                    }
                    content = splittedTitlePoints;
                    
                  } else {
                        List<String> indvRows = splittedTitlePoints.split('\n');
                      for (int j=0; j < indvRows.length; j++) {
                            // Sample content
                            //2. **Fort Architecture and Fortifications**: He extensively developed and fortified hill forts across Maharashtra, making use of the region's geographical advantages. These forts, such as Rajgad, Raigad, and Sinhagad, served as defensive bastions and helped secure his territories.
                            //2. **Sensors and Trackers**: - VR systems use sensors to detect the position and orientation of the HMD and controllers.
                            print('length ====> ${indvRows.length}');
                            
                            if (indvRows.length == 1) {
                                List<String> line = indvRows[j].split(':');  
                                for (int k=0; k < line.length; k++) {

                                    if (k == 0) {
                                        if(line[0].contains('. **')){
                                            title = line[0].split('. **')[1].replaceAll('-', '').replaceAll('*', '').trim();
                                        } else {
                                            title = line[0].replaceAll('-', '').replaceAll('*', '').trim();
                                        }
                                    } else {
                                      content += line[k].replaceAll('-', '').replaceAll('*', '').trim() + '\n';
                                    }
                                    
                                }
                                // print('-> ${title}   ====>  ${content}'  );
                            } else {
                              
                                if (j == 0) {
                                    if(indvRows[0].contains('. **')){
                                        title = indvRows[0].split('. **')[1].replaceAll('-', '').replaceAll('*', '').trim();
                                    } else {
                                        title = indvRows[0].replaceAll('-', '').replaceAll('*', '').trim();
                                    }
                                } else {
                                    content += indvRows[j].replaceAll('#', '').replaceAll('-', '').replaceAll('*', '').trim().trim() + '\n';
                                }  
                                // print('-> ${title}   ====>  ${content}'  );

                            }
                      }
                  }
                  // for (int j=0; j < indvRows.length; j++) {
                  //   // Sample content
                  //   //2. **Fort Architecture and Fortifications**: He extensively developed and fortified hill forts across Maharashtra, making use of the region's geographical advantages. These forts, such as Rajgad, Raigad, and Sinhagad, served as defensive bastions and helped secure his territories.
                        
                  //       List<String> line = indvRows[j].split(':');  
                  //       for (int k=0; k < line.length; k++) {

                  //           // print('\n');
                  //           if (line.length > 0) {
                                
                  //               if (line[0].length > 0 && line[0].contains('- **')) {
                  //                 title = line[0].replaceAll('- **', '').replaceAll('*', '').trim();
                  //               } else if (line[0].length > 0 && line[0].contains('**')) {
                  //                 title = line[0].split('. **')[1].replaceAll('#', '').replaceAll('*', '').trim();
                  //               }
                                
                  //               if (line.length > 1) {
                  //                   content = line[1].trim();
                  //               }
                  //              print('-> ${line[0]}   ====>  ${title}'  );
                  //           }
                            
                  //       }
                  //  }

                  
                
                  if (title.isNotEmpty) {
                      // String imageUrl = _listImageUrls[0];
                      // Uint8List imageBytes =  await BlogImageProvider().getNetworkImage(imageUrl);

                      checkListProvider.addContent(title, content, '', Uint8List.fromList([]));
                  } 
                  title = '';
                  content = '';
                  //print('Title: ${title}  \n  Content : ${content}' );
                  // print('\n');
                  
            }
            checkListProvider.notify();
            
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
            String prompt = "Provide detail description with a format of **topic**:\nparagraphs by occurance order on :";
            prompt= "Avoid extra spaces, escape notations such as \n etc, from the result. Provide big detail description for a blog. Result in format of { \"data\" : [{\"topic\": \"\", \"paragraph\": ''}, {\"topic\": '', \"paragraph\": ''}] } by occurance order on :";
            
            String resp = await openAIHandler().getChatGPTResponse('$prompt $facts');
            // String resp = await openAIHandler().getChatGPTResponse('provide 15 facts in number points and no extra content on:- $domain: $topic');
            
            // String resp = "**Birth and Early Life:**\nMahatma Gandhi was born on October 2, 1869, in Porbandar, a coastal town in present-day Gujarat, India. His full name was Mohandas Karamchand Gandhi, and he would later become renowned as the 'Father of the Nation' in India due to his significant role in the country's struggle for independence from British rule.\n\n**Concept of Satyagraha:**\nThe term 'Satyagraha' was coined by Mahatma Gandhi in 1906. This concept highlighted the power of truth and nonviolent resistance as a means of social and political change. Gandhi introduced this approach as a means to secure rights through nonviolent protests and civil disobedience, believing in the moral power of nonviolence as opposed to physical violence.\n\n**First Application in South Africa:**\nThe first successful application of Satyagraha was during the Indian community's struggle in South Africa. Gandhi lived in South Africa for over two decades, where he developed his philosophy of nonviolent resistance. The movement began in response to discriminatory laws against Indians and was characterized by protests and noncompliance with the unjust laws, ultimately leading to reforms.\n\n**Kheda Satyagraha of 1918:**\nOne of the notable applications of Satyagraha in India was the Kheda Satyagraha of 1918. This movement involved peasants in the Kheda district of Gujarat who demanded relief from taxes due to crop failure and famine conditions. Gandhi organized the farmers and helped orchestrate a nonviolent protest against tax collection, which eventually led to the suspension of tax recovery and some relief for the farmers.\n\n**Boycotts and the Fight for Independence:**\nGandhi's strategy for Indian independence also included widespread boycotts of British goods, schools, and institutions. This was part of the broader non-cooperation movement, aiming to weaken the British economic and administrative grip on India. The boycott effectively mobilized millions of Indians to stop buying British products and to withdraw from British-run educational and administrative institutions.\n\n**Economic Impact:**\nThe boycott and other forms of nonviolent resistance had a significant economic impact, causing a decline in British imports and a dent in the colonial economy. This form of economic noncooperation demonstrated the power of collective action, severely affecting British economic interests in India and strengthening the resolve and unity among Indians fighting for independence.\n\nGandhi's innovative use of Satyagraha through various movements set a precedent for nonviolent resistance worldwide, influencing figures like Martin Luther King Jr. and Nelson Mandela in their respective struggles for civil rights and freedom.";
            // String resp = "{ \n    \"data\": [\n        {\n            \"topic\": \"Salt March\",\n            \"paragraphs\": \"The Salt March, also known as the Dandi March, was a critical event in the Indian independence movement, led by Mahatma Gandhi in 1930. This non-violent act of civil disobedience spanned approximately 240 miles, starting from the Sabarmati Ashram in Ahmedabad and culminating at the coastal village of Dandi in Gujarat. Gandhi and his followers aimed to protest the British salt monopoly, which imposed taxes on Indian salt production and sale, severely affecting the common people. The march began on March 12, 1930, and concluded on April 6, 1930, when Gandhi made salt from seawater, symbolizing the defiance of British laws. This act galvanized the Indian population, demonstrating the power of peaceful protest and greatly increasing momentum towards India's quest for independence.\"\n        },\n        {\n            \"topic\": \"Satyagraha\",\n            \"paragraphs\": \"Satyagraha, meaning 'truth force,' is a methodology of non-violent resistance developed by Mahatma Gandhi. Grounded in the belief that truth and non-violence are inherently interlinked, satyagraha was not merely a political tool but a way of life. Gandhi believed that one must adhere to truth and non-violence to confront injustice effectively. This concept allowed him to cultivate resistance movements that demanded moral high ground and aimed to transform adversaries through understanding and dialogue rather than physical force. Satyagraha played a pivotal role in India's independence struggle as it empowered people to resist British colonial rule without resorting to violence, legitimizing Indian demands on ethical grounds.\"\n        },\n        {\n            \"topic\": \"Non-Cooperation Movement\",\n            \"paragraphs\": \"Launched by Mahatma Gandhi in 1920, the Non-Cooperation Movement was a major campaign of civil disobedience and a significant facet of India's struggle for independence. Stemming from the discontent following the Jallianwala Bagh massacre and the imposition of harsh British policies, this movement sought to attain self-governance and reduce British dominance in India by refusing to comply with its authorities. Gandhi urged Indians to withdraw from British institutions, boycott foreign goods, and uphold Indian values and implements. Although the movement was suspended due to escalation into violence, its impact was substantial, marking a mass mobilization under Gandhi's leadership and sowing seeds for future independence endeavors.\"\n        },\n        {\n            \"topic\": \"Gandhi's Strategy for Indian Independence\",\n            \"paragraphs\": \"Gandhi's approach to Indian independence was multidimensional, involving not just political defiance but also social and economic reform. His strategies were encapsulated in large-scale movements like the Non-Cooperation Movement, the Civil Disobedience Movement, and the Quit India Movement. Gandhi aimed to build a self-reliant, united Indian society capable of resisting colonial rule through non-violent means. His emphasis on swadeshi, or the use of Indian-made goods, and promoting Khadi, homespun cloth, was part of his broader vision for an independent India. By advocating for societal reforms such as the removal of untouchability and uplifting rural India, Gandhi laid the groundwork for a new India that pursued political sovereignty alongside social justice.\"\n        },\n        {\n            \"topic\": \"Gandhi's Autobiography\",\n            \"paragraphs\": \"Mahatma Gandhi's autobiography, 'The Story of My Experiments with Truth' (Aatma Katha), is a deeply introspective account of his life and philosophical evolution. While Gandhi reflects comprehensively on various personal and political journeys, the book does not provide detailed coverage of each movement he led. It focuses more on the principles and events that shaped his beliefs rather than chronicling detailed historical accounts, giving readers insight into how his ideological underpinnings, such as truth and non-violence, evolved. This work serves as a testament to his continuous quest for self-improvement and his devotion to practicing what he considered truthful living, offering valuable philosophical insights into the man behind India’s freedom struggle.\"\n        }\n    ]\n}";
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
            // checkListProvider.setFinalContent();


            
            // List<String> responses = resp.split('\n\n');
            // for (int i=0; i < responses.length; i++) {

            //       // "**Birth and Early Life:**\nMahatma Gandhi was born on October 2, 1869, in Porbandar, a coastal town in present-day Gujarat, India. His full name was Mohandas Karamchand Gandhi, and he would later become renowned as the 'Father of the Nation' in India due to his significant role in the country's struggle for independence from British rule.
                  
            //       String title='';
            //       String content = '';
            //       List<String> paragraph;
            //       if (responses[i].contains(': ')) {
            //         paragraph = responses[i].split(': ');  
            //       } else {
            //         paragraph = responses[i].split('\n');  
            //       }
                  

            //       for (int j=0; j < paragraph.length; j++) {
                      
            //           if (j == 0) {
            //               title = paragraph[0].replaceAll('*','').replaceAll('#', '');
            //           } else {
            //               content += paragraph[j].replaceAll('*', '#').replaceAll('#', '').replaceAll('"', '');
            //           }
                      
            //           //print('Title: ${title}  \n  Content : ${content}' );
            //           // print('\n');
            //       }
            //       print('Title: ${title}  \n  Content : ${content}' );

            //       checkListProvider.addContent(title, content, '', Uint8List.fromList([],), isSelected: true );
            // }
            // checkListProvider.setFinalContent();

            return true;
        } catch (e) {
            print(e.toString());
           return false;
        }
  }

  /// this method will regenerate block specific content
  /// it will get the topic title and content from openai
  /// and regenerate the block content
  Future<bool> regenerateBlockContent(BuildContext context, String title, String content) async {
    try {

      CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);

      String prompt = 'Avoid extra spaces, escape notations such as \\n etc, from the result. Provide big detail description for a blog. Result in format of { \"data\" : [{\"topic\": \"\", \"paragraph\": \'\'}}  on';
      String resp = await openAIHandler().getChatGPTResponse('${prompt} ${title.trim()} : ${content.trim()}');
      
      resp = resp.replaceAll('\n', '').replaceAll('  ', '').replaceAll('`', '').replaceAll('json', '');
      List<dynamic> data =  jsonDecode(resp)['data'];

      for (int i=0; i < data.length; i++) {

        String subTitle = data[i]['topic'];
        String subContent = data[i]['paragraph'];

        if (subTitle != null && subContent != null) {
          int index = checkListProvider.listFinalContent.indexWhere((element) => element.name == title);
          if (index != -1) {
            checkListProvider.listFinalContent[index] = ModelBlogData(name: subTitle, content: subContent, imageUrls: checkListProvider.listFinalContent[index].imageUrls, imageBytes: checkListProvider.listFinalContent[index].imageBytes, tabularData: checkListProvider.listFinalContent[index].tabularData, selected: true );
          } else {
            checkListProvider.addContent(subTitle, subContent, content, Uint8List.fromList([],), isSelected: false );
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


Future<bool> getStatsData(BuildContext context, String prompt) async {
  try {
      String perPrompt = 'provide numerical data only with no extra text in json format:';
      String jsonData = await openAIHandler().getChatGPTResponse("${perPrompt} $prompt");
      
      // String jsonData = "```json\n{\n    \"2011\": 4500000,\n    \"2012\": 4800000,\n    \"2013\": 5100000,\n    \"2014\": 5500000,\n    \"2015\": 6000000,\n    \"2016\": 6200000,\n    \"2017\": 6500000,\n    \"2018\": 6900000,\n    \"2019\": 7300000,\n    \"2020\": 7000000,\n    \"2021\": 7500000,\n    \"2022\": 8000000\n}\n```";

      jsonData = jsonData.replaceAll('`', '').replaceAll('\\', '').replaceAll('\n', '').replaceAll('json', '');

      print('------------> $jsonData');

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


