import 'dart:typed_data';

import 'package:blog_creator/Provider/Loaderprovider.dart';
import 'package:blog_creator/controller/DataController.dart';
import 'package:blog_creator/Research.dart';
import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Utils/BlogImageProvider.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:blog_creator/Network/openAIHandler.dart';
import 'package:blog_creator/components/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/ComponentButton.dart';


class SelectTopic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    LoaderProvider loaderProvider = Provider.of<LoaderProvider>(context, listen: false);

    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB), // Light background color
      body: SingleChildScrollView(
        child: Padding(
          padding:  const EdgeInsets.only(left: 30, right: 30, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title

            Text('Domain', style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 3),
              Text(
                Provider.of<ReviewProvider>(context, listen: false).title,
                textAlign: TextAlign.center,
                style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A),),
              ),
              SizedBox(height: 12),
      
              // Radio Options
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                child: Consumer<ReviewProvider>( builder: (context, titleProvider, child) {
                
                    print('------------ ${titleProvider.topics.length}');
                    return Column(
                      children: titleProvider.topics.map((title) {
                        return RadioListTile<String>(
                          value: title,
                          groupValue: titleProvider.selectedTopic,
                          onChanged: (value) {
                            titleProvider.selectTopic(value!);
                          },
                          title: Text(title),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 24), // Spacing
      
              // Add Your Own Topic Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "add your own topic",
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
                  SizedBox(width: 8), // Spacing
      
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Color(0xFF4A55C2),
                    ),
                  ),
      
                  SizedBox(width: 16), // Spacing
      
                  // Re-generate Button
                  ComponentButton(
                   title: 'Find more topics',
                   onTap: () async {

                         if (_controller.text.trim().isEmpty) {
                           CustomDialog().showCustomDialog(context, 'Error', 'Please add your own topic');
                         } else {

                           loaderProvider.setLoading(true);
                           bool response = await DataController().fetchTitleData(context, _controller.text.trim());
                           loaderProvider.setLoading(false);

                           if (response) {
                             NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                             homePageProvider.setPage(1);
                           } else {
                               CustomDialog().showCustomDialog(context, 'Error', 'Something went wrong');
                           }
                         }
                  },),
                  
                  SizedBox(width: 16), // Spacing
                  // Next Button
                 
                  ComponentButton(
                   title: 'Next',
                   onTap: () async {

                        //  try {
                        //       String blogTitle = Provider.of<ReviewProvider>(context, listen: false).title;
                        //       String blogTopic = Provider.of<ReviewProvider>(context, listen: false).selectedTopic;   
                        //       bool executed =  await DataController().getTopicDetails(context, blogTitle, blogTopic);
                        //       if (executed) {
                        //           NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                        //           homePageProvider.setPage(2);
                        //       } else {
                        //         print('=== >Something went wrong');
                        //         CustomDialog().showCustomDialog(context, 'Error', 'Something went wrong');
                        //       }

                        //  } on Exception catch (e) {
                        //     print('=== > ${e.toString()}');
                        //     CustomDialog().showCustomDialog(context, 'Error', e.toString());
                        //  }
                        NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                        homePageProvider.setPage(2);
                         

                        
                  },),
                ],
              ),
      
      
      
            ],
          ),
        ),
      ),
    );
  }




  Widget buildRadioTile(String title) {
    return RadioListTile(
      value: title,
      groupValue: null, // Replace with a variable for selected value
      onChanged: (value) {
        // Handle radio button selection
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF4A4A4A),
        ),
      ),
      activeColor: Color(0xFF4A55C2),
    );
  }
}
