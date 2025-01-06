import 'dart:convert';
import 'dart:js';

import 'package:blog_creator/controller/DataController.dart';
import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/components/ComponentButton.dart';
import 'package:blog_creator/components/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Research2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      
      backgroundColor:  Color(0xFFF1F5F9), // Light grayish blue,
      body: Padding(
        padding:  const EdgeInsets.only( left: 30, right: 30, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
                Provider.of<ReviewProvider>(context, listen: false).title,
                style: const TextStyle( fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A), ),
              ),
              SizedBox(height: 18), // Spacing
            Expanded(
              child: Row(
              children: [
                Expanded(
                  flex : 2,
                  child: Consumer<CheckListProvider>(
                    builder: (context, dishProvider, child) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 4), ), ], ),
                        child: ListView.builder(
                          // itemCount: dishProvider.listSelectedContent.length,
                          itemCount: dishProvider.listFinalContent.length,
                          itemBuilder: (context, index) {
              
                            // final dish = dishProvider.listSelectedContent[index];
                            final dish = dishProvider.listFinalContent[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: dish.selected,
                                  onChanged: (bool? value) {
                                    dishProvider.toggleModeContentSelection(index);
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [

                                      Padding(
                                            padding: const EdgeInsets.only(top: 6.0),
                                            child: Text(dish.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                                      ),

                                      Padding(
                                          padding: const EdgeInsets.only(top: 2.0),
                                          child: Text(dish.content.trim(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300) ),
                                      ),
                                      SizedBox(height: 10),
                                      
                                    ],
                                  ),
                                ),
                              ],
                            );
              
              
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),



              ],
                            ),
            ),
            SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Add more facts",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: TextStyle(
                              color: Color(0xFF9E9E9E), // Hint text color
                            ),
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    ComponentButton(title: 'Add more facts', onTap: () {

                      if (_controller.text.isNotEmpty) {
                          
                          String blogTitle = Provider.of<ReviewProvider>(context, listen: false).title;
                          // String blogTopic = Provider.of<ReviewProvider>(context, listen: false).selectedTopic;   
                          DataController().getTopicDetails(context, blogTitle, _controller.text).then((value) {
                              if (value) {
                                print('======> $value');
                                CheckListProvider().notify();
                                _controller.clear();

                              } else {
                                  CustomDialog().showCustomDialog(context, 'Error', 'Failed to fetch topic details. Please try again.');
                              }
                         });
                      }
                      
                    },),

                    SizedBox(width: 16),

                    ComponentButton(title: 'Back', onTap: () {
                      NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                        homePageProvider.setPage(1);
                    },),

                    SizedBox(width: 16),

                    ComponentButton(
                     title: 'Authoring',
                     onTap: () {

                        CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
                        // List<ModelBlogData> content = checkListProvider.listSelectedContent
                        //     .where((item) => item.selected)
                        //     .toList();

                        // checkListProvider.setFinalContent();

                        // ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
                        
                        // reviewProvider.setOrigContent(content);
                        


                        NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                        homePageProvider.setPage(3);

                    }),

              
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // _listImageUrls
  
  

  Widget _buildImagePlaceholder(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
  
  getContent(String content) {

    
        
        if(content.contains('- **')) {
            // print(' print this in bullet : $text');
            String value = content.replaceAll('**', '').replaceAll('-', '').trim();
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text('${value}' , style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600) ),
                ),
              ],
            );
        }else if(content.contains('**')) {
            return Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(content.replaceAll('**', '').trim(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), ),
            );
        } else {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(content.trim(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300) ),
            );
        }
        

  }
  
  // getContent(List<String> content) {

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: content.map((text) {
        
  //       if(text.contains('- **')) {
  //           // print(' print this in bullet : $text');
  //           String value = text.replaceAll('**', '').replaceAll('-', '').trim();
            
  //           return Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 5.0),
  //                 child: Text('${value}' , style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600) ),
  //               ),
  //             ],
  //           );
  //       }else if(text.contains('**')) {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 5.0),
  //             child: Text(text.replaceAll('**', '').trim(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), ),
  //           );
  //       } else {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 2.0),
  //             child: Text(text.trim(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300) ),
  //           );
  //       }
        

  //     }).toList(),
  //   );
  // }


}