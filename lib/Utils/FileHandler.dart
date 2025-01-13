import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Model/ModelFile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Provider/ResearchProvider.dart';
import 'package:blog_creator/Provider/ResearchDataProvider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';
import 'dart:io';


class FileHandler {
  

static Future<void> readFromFile(BuildContext context) async {
  final html.FileUploadInputElement input = html.FileUploadInputElement();
  input.accept = '.json'; // Specify accepted file types if needed
  input.onChange.listen((e) async {
    final List<html.File>? files = input.files;
    if (files != null && files.isNotEmpty) {
      final html.File file = files.first;
      final html.FileReader reader = html.FileReader();
      reader.readAsText(file);
      reader.onLoadEnd.listen((e) {

          final fileContent = reader.result;

          CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
          ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
          ResearchProvider researchProvider = Provider.of<ResearchProvider>(context, listen: false);
          ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);
          ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);

          // final jsonData = jsonDecode(fileContent.toString());
          
          print("0.1 ----------- ${fileContent.toString()} ");
          // print("0.1 ----------- ${jsonDecode(fileContent.toString())} ");
          Map<String, dynamic> jsonData = jsonDecode(fileContent.toString());
          // print('Type of jsonData: ${jsonData.runtimeType}');
          
          // print('-----> ${(fileContent['checkList'] as List<ModelBlogData>)}');


          print('0.1 ----------- ');
          ModelFile modelFile = ModelFile.fromJson(jsonData);
          // final Map<String, dynamic> jsonData = jsonDecode(fileContent) as Map<String, dynamic>;
          // final Map<String, dynamic> jsonData = jsonDecode(fileContent);
          print('0.2 ----------- ');
          // ModelFile modelFile = ModelFile.fromJson(jsonData);
          // print('0.4 -----------');
          try {
            

            checkListProvider.setFinalContent(modelFile.checkList);
            print('1 -----------');
            reviewProvider.setOrigContent(modelFile.review!.listOrigContent);
            
            print('2 -----------');
            reviewProvider.setFinalContent(modelFile.review!.listFinalContent);
            
            print('3 -----------');
            reviewProvider.setSuggestedTopics(modelFile.review!.listSuggestedTopics );

            print('4 -----------');
            reviewProvider.setSelectedLanguage('${modelFile.review!.selectedLanguage}');

            print('5 -----------');
            reviewProvider.setSelectedTemplateName('${modelFile.review!.selectedTemplateName}');

            print('6 -----------');
            reviewProvider.setTitle('${modelFile.review!.title}');


            print('7 -----------');
            // reviewProvider.setFinalTitle('${data['review']['finalTitle']}');
            reviewProvider.selectTopic('${modelFile.review!.selectedTopic}');
            // reviewProvider.setSelectedTopic(data['review']['selectedTopic']);

            print('8 -----------');
            researchProvider.setTabs(modelFile.research?.tabs ?? []);
            
            print('9 -----------');
            researchProvider.setSelectedTabName(modelFile.research?.selectedTabName ?? '');

            print('10 -----------');
            researchDataProvider.setFactData(modelFile.researchData?.facts?? {});
            
            print('11 -----------');
            researchImageProvider.setSelectedImages(modelFile.researchImage?.images ?? []);

            print('12 -----------');
            researchImageProvider.setWebImages(modelFile.researchImage?.webImages ?? []);
            print('13 -----------');
            researchImageProvider.setAIImages(modelFile.researchImage?.aiImages ?? []);

            print('14 -----------');
            researchImageProvider.setModelStatsList(modelFile.researchImage?.modelStats ?? <ModelStats>[]);
            print('15 -----------');
            researchImageProvider.setModelTableList(modelFile.researchImage?.modelTable ?? <ModelStats>[]);
        
          } catch (e) {
            print('Error parsing JSON: $e');
          }
          

      });
    }
  });
  input.click();
}

static Future<void> saveToLocalStorage(BuildContext context) async {
    
    CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    ResearchProvider researchProvider = Provider.of<ResearchProvider>(context, listen: false);
    ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);
    ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);


    ModelFile modelFile = ModelFile(
      checkList: checkListProvider.listFinalContent,
      review: Review(
        title: reviewProvider.title,
        finalTitle: reviewProvider.finalTitle,
        selectedTopic: reviewProvider.selectedTopic,
        finalSelectedTopic: reviewProvider.finalSelectedTopic,
        listOrigContent: reviewProvider.listOrigContent,
        listFinalContent: reviewProvider.listFinalContent,
        listSuggestedTopics: reviewProvider.suggestedTopics,
        selectedLanguage: reviewProvider.selectedLanguage,
        selectedTemplateName: reviewProvider.selectedTemplateName,
      ),
      research: Research(
        tabs: researchProvider.tabs,
        selectedTabName: researchProvider.selectedTabName,
      ),
      researchData: ResearchData(
        facts: researchDataProvider.getAllFacts(),
      ),
      // researchImage: ResearchImage(
      //   images: researchImageProvider.selectedImages,
      //   webImages: researchImageProvider.webImages,
      //   aiImages: researchImageProvider.aiImages,
      //   modelStats: researchImageProvider.modelStats,
      //   modelTable: researchImageProvider.modelTable,
      // ),
    );

    
    // print('----> ${modelFile.toJson()}');
    final data = jsonEncode(modelFile.toJson());
    print('----> ${data}');

    // final data = {
      
    //   'checkList': jsonEncode(checkListProvider.listFinalContent.map((data) {
    //     return {
    //       'name': data.name,
    //       'imageUrls': data.imageUrls,
    //       'imageBytes': data.imageBytes,
    //       'content': data.content,
    //       'selected': data.selected,
    //       'tabularData': data.tabularData,
    //     };
    //   }).toList()),
    //   'review': {
    //     'title': reviewProvider.title,
    //     'finalTitle': reviewProvider.finalTitle,
    //     'selectedTopic': reviewProvider.selectedTopic,
    //     'finalSelectedTopic': reviewProvider.finalSelectedTopic,
        
    //     'listOrigContent': jsonEncode(reviewProvider.listOrigContent.map((data) {
    //           return {
    //             'name': data.name,
    //             'imageUrls': data.imageUrls,
    //             'imageBytes': data.imageBytes,
    //             'content': data.content,
    //             'selected': data.selected,
    //             'tabularData': data.tabularData,
    //           };
    //         }).toList()),
    //     'listFinalContent': jsonEncode(reviewProvider.listFinalContent.map((data) {
    //           return {
    //             'name': data.name,
    //             'imageUrls': data.imageUrls,
    //             'imageBytes': data.imageBytes,
    //             'content': data.content,
    //             'selected': data.selected,
    //             'tabularData': data.tabularData,
    //           };
    //         }).toList()),
        
    //     'listSuggestedTopics': reviewProvider.suggestedTopics,
        
    //     'selectedLanguage': reviewProvider.selectedLanguage,
    //     'selectedTemplateName': reviewProvider.selectedTemplateName,
        
    //   },
    //   'research': {
    //     'tabs': researchProvider.tabs,
    //     'selectedTabName': researchProvider.selectedTabName,
    //   },
    //   'researchData': {
    //     'facts': jsonEncode(researchDataProvider.factData.map((key, facts) => MapEntry(key, facts.map((fact) => {'factName': fact.factName, 'isSelected': fact.isSelected}).toList()))),
    //   },
    //   'researchImage': {
    //     'images': researchImageProvider.selectedImages,
    //     'webImages': jsonEncode(researchImageProvider.webImages.map((image) => {'imageUrl': image.imageUrl, 'isSelected': image.isSelected}).toList()),
    //     'aiImages': jsonEncode(researchImageProvider.aiImages.map((image) => {'imageUrl': image.imageUrl, 'isSelected': image.isSelected}).toList()),
    //     'modelStats': jsonEncode(researchImageProvider.modelStats.map((modelStat) => {
    //       'stats': modelStat.stats,
    //       'url': modelStat.url,
    //       'type': modelStat.type,
    //       'isSelected': modelStat.isSelected,
    //     }).toList()),
    //     'modelTable': jsonEncode(researchImageProvider.modelTable.map((modelStat) => {
    //       'stats': modelStat.stats,
    //       'url': modelStat.url,
    //       'type': modelStat.type,
    //       'isSelected': modelStat.isSelected,
    //     }).toList()),
    //   },
     
    // };
    print('4 -------------------');

    final fileName = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Save to local storage'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'File name',
              hintText: 'Enter file name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            )
          ],
        );
      }
    );

    // print('Data:  ${modelFile.toJson()}');


    final blob = html.Blob([data], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final link = html.document.createElement('a') as html.AnchorElement;
    link.href = url;
    link.download = '$fileName.json';
    link.click();
    html.Url.revokeObjectUrl(url);

  }
}
