import 'dart:convert';
import 'dart:typed_data';

import 'package:blog_creator/Provider/Loaderprovider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';
import 'package:blog_creator/controller/DataController.dart';
import 'package:blog_creator/controller/ImageController.dart';
import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Network/RapidApiHandler.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Utils/BlogImageProvider.dart';
import 'package:blog_creator/components/CompContainer.dart';
import 'package:blog_creator/components/CompTextField.dart';
import 'package:blog_creator/components/ComponentButton.dart';
import 'package:blog_creator/components/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Authoring extends StatefulWidget {
  @override
  _Authoring createState() => _Authoring();
}

class _Authoring extends State<Authoring> with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _controller = TextEditingController();
  TextEditingController _contTitle = TextEditingController();
  TextEditingController _contSubTitle = TextEditingController();

  late LoaderProvider loaderProvider;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    loaderProvider = Provider.of<LoaderProvider>(context, listen: false);

    _contTitle.text =Provider.of<ReviewProvider>(context, listen: false).title;
    _contSubTitle.text =Provider.of<ReviewProvider>(context, listen: false).selectedTopic;

    
  // if (chkProvider.listFinalContent.isEmpty) {
  //     chkProvider.addContent('Title 1', 'Content 1', '', Uint8List.fromList([]), isSelected: true);
  //     chkProvider.addContent('Title 2', 'Content 2', '', Uint8List.fromList([]),  isSelected: true);
  //     chkProvider.addContent('Title 3', 'Content 3', '', Uint8List.fromList([]),  isSelected: true);

    
  //     chkProvider.setFinalContent();
  //   }
    

    return Scaffold(
      
      backgroundColor:  Color(0xFFF1F5F9), // Light grayish blue,
      body: Padding(
        padding:  const EdgeInsets.only( left: 30, right: 30, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Text('Blog Title', style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 3),
            
            CompTextField.getEditText(controller: _contTitle, hint: 'Write your blog topic here'),
            const SizedBox(height: 15),

            const Text('Sub Topic', style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 3),
            
            CompTextField.getEditText(controller: _contSubTitle, hint: 'Write your blog sub - topic here'),
            const SizedBox(height: 15), // Spacing
            
            Expanded(
              child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Consumer<CheckListProvider>(
                    builder: (context, checkListProvider, child) {

                      return CompContainer.getContainer(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: checkListProvider.listFinalContent.length,
                          itemBuilder: (context, index) {

                            final block = checkListProvider.listFinalContent[index];
                            final TextEditingController controller = TextEditingController(text: block.name);
                            final TextEditingController tecTable = TextEditingController(text: block.tabularData);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                    
                                        DragTarget<String>(
                                          onAcceptWithDetails: (details) {
                                            // Handle the accepted data
                                            if (details.data.contains('|')) {
                                              // checkListProvider.listFinalContent[index].content = '${checkListProvider.listFinalContent[index].content}\n\n${details.data}';
                                              checkListProvider.listFinalContent[index].tabularData = details.data;
                                            } else {
                                              checkListProvider.listFinalContent[index].imageUrls = details.data;
                                              // checkListProvider.listFinalContent[index].imageBytes = BlogImageProvider().getNetworkImage(details.data);
                                            }
                                            
                                            checkListProvider.notify();
                                    
                                          },
                                          builder: (context, candidates, rejected) {
                                            return Stack(
                                              children: [
                                                CompTextField.getEditText(
                                                  controller: controller,
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                                                  onChanged: (value) {
                                                    checkListProvider.listFinalContent[index].name = value;
                                                  },
                                                ),
                                                Positioned(
                                                  top: -5,
                                                  right: 0,
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons.close, size: 18, color: Colors.red),
                                                        tooltip: 'Remove this content',
                                                        onPressed: () {
                                                          checkListProvider.listFinalContent.removeAt(index);
                                                          checkListProvider.notify();
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.replay, size: 18, color: Colors.blue),
                                                        tooltip: 'Regenerate this content',
                                                        onPressed: () async {
                                                          loaderProvider.setLoading(true);
                                                          await DataController().regenerateBlockContent(context, checkListProvider.listFinalContent[index].name, checkListProvider.listFinalContent[index].content);
                                                          loaderProvider.setLoading(false);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        getContent(checkListProvider, index),

                                        Visibility(
                                          visible: block.tabularData != '',
                                          child: Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: Stack(
                                                children: [
                                                  TextField(
                                                    controller: tecTable,
                                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300, fontFamily: 'CourierPrime',),
                                                    maxLines: null,
                                                    onChanged: (newValue) {
                                                      checkListProvider.listFinalContent[index].tabularData = newValue;
                                                    },
                                                    decoration: const InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                                      border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close, size: 18, color: Colors.red),
                                                      tooltip: 'Remove this content',
                                                      onPressed: () {
                                                        checkListProvider.listFinalContent[index].tabularData = '';
                                                        checkListProvider.notify();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ),

                                        SizedBox(height: 25),
                                      ],
                                    ),
                                  ),
                              
                                  Visibility(
                                    visible: block.imageUrls != '',
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Stack(
                                        children: [
                                          Image.network( block.imageUrls, width: 100, height: 100, fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: IconButton(
                                              icon: const Icon(Icons.close, color: Colors.red),
                                              onPressed: () {
                                                checkListProvider.listFinalContent[index].imageUrls = '';
                                                checkListProvider.notify();
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                              
                                ],
                              ),
                            );
                          },
                        ),
                      );

                    },
                  ),
                ),
                SizedBox(width: 16),


                Visibility(
                  visible: Provider.of<ResearchImageProvider>(context).selectedImages.isNotEmpty,
                  child: Expanded(
                    child: Consumer<ResearchImageProvider>(
                      builder: (context, researchImageProvider, child) {

                        return ListView.builder(
                          itemCount: researchImageProvider.selectedImages.length,
                          itemBuilder: (context, index) {

                            if (researchImageProvider.selectedImages[index].contains('|')) {

                                print('Display table');
                                return Draggable<String>(
                                  data: researchImageProvider.selectedImages[index],
                                  feedback: Text(
                                          researchImageProvider.selectedImages[index],
                                          style: const TextStyle(fontSize: 6, fontFamily: 'CourierPrime',),
                                        ),
                                  childWhenDragging: Container(),
                                  child: Text(
                                          researchImageProvider.selectedImages[index],
                                          style: const TextStyle(fontSize: 9, fontFamily: 'CourierPrime',),
                                        ),
                                  
                                );
                            } else {
                                print('Display image');
                                return Draggable<String>(
                                  data: researchImageProvider.selectedImages[index],
                                  feedback: Image.network(
                                          researchImageProvider.selectedImages[index],
                                          width: 200,
                                          height: 200,
                                        ),
                                  childWhenDragging: Container(),
                                  child: Image.network(
                                          researchImageProvider.selectedImages[index],
                                          width: 200,
                                          height: 200,
                                        ),
                                  
                                );

                            }

                           
                          },
                        );

                      },
                    ),
                  ),
                ),

              ],
                            ),
            ),
            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Expanded(
                    child: CompContainer.getContainer(
                      child: TextField(
                        controller: _controller,
                        decoration: CompTextField.getInputDecorations(hint: 'Add more facts'),
                        onSubmitted: (value) {
                          addMoreBlockData(_controller.text);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ComponentButton(title: 'Re-Generate', onTap: () {
                      addMoreBlockData(_controller.text);  
                  }),
                  
            
                  SizedBox(width: 16),

                  ComponentButton(title: 'Back', onTap: () {
                      
                      NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                      homePageProvider.setPage(3);
                  },),
                  
                  SizedBox(width: 16),
                  ComponentButton(
                    title: 'Plagiarism',
                    onTap: () async {
                      CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
                      loaderProvider.setLoading(true);
                      final response = await RapidApiHandler().getPlagiarismCheck(Provider.of<ReviewProvider>(context, listen: false).getFinalContent(checkListProvider.listFinalContent));
                      loaderProvider.setLoading(false);
                      if (response > 0) {
                        CustomDialog().showCustomDialog(context, 'Plagiarism Detected', 'Plagiarism percentage: ${response}%');
                      } else {
                        CustomDialog().showCustomDialog(context, 'Success', 'No plagiarism detected.');
                      }
                    },
                  ),

                  SizedBox(width: 16),
                  
                  ComponentButton(
                   title: 'Generate Blog',
                   onTap: () {
            
                      generateBlog(context);
            
                  }),
            
            
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  
  void addMoreBlockData(String value) {
        
        if (value.isNotEmpty) {
          String blogTitle = Provider.of<ReviewProvider>(context, listen: false).title;
          loaderProvider.setLoading(true);
          DataController().regenerateBlockContent(context, blogTitle, value).then((value) {
            loaderProvider.setLoading(false);
            if (value) {
              print('======> $value');
              CheckListProvider().notify();
              _controller.clear();
            } else {
              CustomDialog().showCustomDialog(context, 'Error', 'Failed to fetch topic details. Please try again.');
            }
          });
        }
  }
  
  


Widget getContent(CheckListProvider checkListProvider, int index) {
    
      String text = checkListProvider.listFinalContent[index].content;

      String value = text.replaceAll('**', '').replaceAll('-', '').trim();
      TextEditingController controller = TextEditingController(text: value);

      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: TextField(
          controller: controller,
          // style: text.contains('- **') || text.contains('**') 
          //     ? const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
          //     : const TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
          maxLines: null,
          onChanged: (newValue) {
            // Update the value in ReviewProvider here
            // reviewProvider.listFinalContent[index].content = newValue;
            checkListProvider.listFinalContent[index].content = newValue;
          },
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            border: OutlineInputBorder(),
          ),
        ),
      );

  }
  
  Future<void> generateBlog(BuildContext context) async {


      CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
      ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

      List<ModelBlogData> content = [];

      // if (reviewProvider.hasImage) {
      //   for (int i = 0; i < content.length; i++) {
      //     if (_tabController.index == 0) {
      //       content[i].imageUrls = reviewProvider.listWebImages[i];
      //       Uint8List imageBytes =  await BlogImageProvider().getNetworkImage(reviewProvider.listWebImages[i]);
      //       content[i].imageBytes = imageBytes.buffer.asUint8List();
      //     } else {
      //       content[i].imageUrls = reviewProvider.listAIImages[i];
      //       Uint8List imageBytes =  await BlogImageProvider().getNetworkImage(reviewProvider.listAIImages[i]);
      //       content[i].imageBytes = imageBytes.buffer.asUint8List();
      //     }
      //   }
      // } else {
      //   content = checkListProvider.listFinalContent
      //                     .where((element) => element.selected)
      //                     .toList();
      // }

// await BlogImageProvider().getNetworkImage(element.imageUrls);

      loaderProvider.setLoading(true);
      for (var element in checkListProvider.listFinalContent) {
          if (element.selected) {
            element.imageBytes = await BlogImageProvider().getNetworkImage(element.imageUrls);
            content.add(element);
          }
      }

      // content = checkListProvider.listFinalContent
      //                     .where((element) => element.selected)
      //                     .toList();
      print('generate blog content : ${content.toString()}');
      
      reviewProvider.setTitle(reviewProvider.title);
      reviewProvider.selectTopic(reviewProvider.selectedTopic);
      reviewProvider.clearFinalContent();
      reviewProvider.clearOrigContent();
      reviewProvider.setOrigContent(content);
      loaderProvider.setLoading(false);


      NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
      homePageProvider.setPage(5);
  }
  // Widget getContent(ReviewProvider reviewProvider, int index) {
    
  //   List<String> content = reviewProvider.listFinalContent[index].content;
    
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: content.map((text) {


  //       String value = text.replaceAll('**', '').replaceAll('-', '').trim();
  //       TextEditingController controller = TextEditingController(text: value);

  //       return Padding(
  //         padding: const EdgeInsets.only(top: 5.0),
  //         child: TextField(
  //           controller: controller,
  //           style: text.contains('- **') || text.contains('**') 
  //               ? const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
  //               : const TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
  //           maxLines: null,
  //           onChanged: (newValue) {
  //             // Update the value in ReviewProvider here
  //             // reviewProvider.listFinalContent[index].content = newValue;
  //           },
  //           decoration: const InputDecoration(
  //             isDense: true,
  //             contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //       );


  //     }).toList(),
  //   );
  // }


}
