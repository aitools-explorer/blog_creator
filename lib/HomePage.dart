import 'package:blog_creator/Provider/ResearchDataProvider.dart';
import 'package:blog_creator/Research.dart';
import 'package:blog_creator/ResearchImage.dart';
import 'package:blog_creator/controller/DataController.dart';
import 'package:blog_creator/samplaClass/DragAndDropView.dart';
import 'package:blog_creator/samplaClass/DynamicTabBar.dart';
import 'package:blog_creator/samplaClass/PDFGenerator.dart';
import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/samplaClass/TextExample.dart';
import 'package:blog_creator/Utils/RapidAiImageProvider.dart';
import 'package:blog_creator/Network/WebImagesHandler.dart';
import 'package:blog_creator/components/CompContainer.dart';
import 'package:blog_creator/components/CompTextField.dart';
import 'package:blog_creator/components/ComponentButton.dart';
import 'package:blog_creator/components/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive design
    // final size = MediaQuery.of(context).size;
    
    
    return Container(
      color: Color(0xFFF1F5F9), // Light grayish blue,
      child: Center(
        child: Padding(
          padding:  const EdgeInsets.only( left: 30, right: 30, bottom: 40),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Row for cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeatureCard(
                    assetName: "writer.png",
                    title: "Unleash the writer in you",
                    color: Color(0xFF4A55C2),
                  ),
                  SizedBox(width: 20),
                  _buildFeatureCard(
                    assetName: "gallery.png",
                    title: "Get corresponding image suggestions",
                    color: Color(0xFF4A55C2),
                  ),
                  SizedBox(width: 20),
                  _buildFeatureCard(
                    assetName: "layout.png",
                    title: "Redesign layouts and fine tune content",
                    color: Color(0xFF4A55C2),
                  ),
                ],
              ),
              SizedBox(height: 30), // Spacing between cards and text field

              const Text(
                "Topic Discovery 1",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NotoSans-Regular',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "Choose one of the suggested domains or add your own",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),


              SizedBox(height: 20),

              _getSuggestedTopics(context),
              
              SizedBox(height: 10),

              // Text Field with Search Icon
              CompContainer.getContainer(
                child: TextField(
                  controller: _controller,
                  decoration: CompTextField.getInputDecorations(hint: 'What’s on your mind?...'),
                  onSubmitted: (value) {
                      // Do something
                      fetchSubDomain(context, _controller.text.trim());
                  },
                ),
              ),
              SizedBox(height: 20), // Spacing between text field and button
              // Next Button
              
              
              
              Align(
                  alignment: Alignment.centerRight, // Aligns button to the right
                  child: ComponentButton(
                     title: 'Next',
                     onTap: () async {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResearchImage(),
                          ),
                        );
                        
                        // fetchSubDomain(context, _controller.text.trim());

                        // DataController().getImageData(context, 'prompt');

                        // PDFGenerator pdfTemplate = PDFGenerator();
                        // pdfTemplate.createPdf();

                  }),
                ),

            
              
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchSubDomain(BuildContext context, String topic) async {
        if (topic.isEmpty) {
          CustomDialog().showCustomDialog(context, 'Error', 'Please add some domain or topic');
          return;
        }

        ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
        // reviewProvider.suggestedTopics.
        reviewProvider.setTitle(topic);


        bool response = await DataController().fetchTitleData(context, topic);

        if (response) {
          NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
          homePageProvider.setPage(1);
        } else {
          CustomDialog().showCustomDialog(context, 'Error', 'Something went wrong');
        }
  }

  
  // Helper method to create feature cards
  Widget _buildFeatureCard({required String assetName, required String title, required Color color}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 25, bottom: 25, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: 12),
            
            // Icon(icon, size: 40, color: color),

            Image.asset(
                assetName, // Replace with actual image asset or network image
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),

          ],
        ),
      ),
    );
  }


  
  // Method to get suggested topics
  Widget _getSuggestedTopics(BuildContext context) {

    // Get data from OpenAI API
    return FutureBuilder(
      future: DataController().fetchSuggestedTopics(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return  Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (Provider.of<ReviewProvider>(context, listen: false).suggestedTopics.length / 5).ceil(),
                    itemBuilder: (context, index) {
                      return Row(
                        
                        children: [
                          for (int i = 0; i < 5; i++)
                            if (index * 5 + i < Provider.of<ReviewProvider>(context, listen: false).suggestedTopics.length)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ComponentButton(
                                    onTap: () {
                                      
                                      _controller.text  = Provider.of<ReviewProvider>(context, listen: false).suggestedTopics[index * 5 + i];
                                      fetchSubDomain(context, _controller.text.trim());
                                      
                                    },
                                    
                                    title: Provider.of<ReviewProvider>(context, listen: false).suggestedTopics[index * 5 + i],
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                              ),
                        ],
                      );
                    },
                  );
              },
            );
        },
    );

        
  }
}