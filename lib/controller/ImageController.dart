
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/CheckboxProvider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Network/RapidAiImageHandler.dart';
import 'package:blog_creator/Network/WebImagesHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';

class ImageController {
  

   Future<void> toggleHasImage(BuildContext context) async {
    
    // update ReviewProvider with ResearchImageProvider
      CheckboxProvider checkBoxProvider = Provider.of<CheckboxProvider>(context, listen: false);
      ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
      ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);

      checkBoxProvider.toggleHasImage();

      if (checkBoxProvider.hasImage) {
          if (researchImageProvider.webImages.isEmpty) {
            await loadWebImages(context, reviewProvider.title, reviewProvider.selectedTopic);
          }
          if (researchImageProvider.aiImages.isEmpty) {
            await loadAIImages(context, reviewProvider.title, reviewProvider.selectedTopic);
          }
      }
      researchImageProvider.notify();

  }

  loadWebImages (BuildContext context, String title, String selectedTopic) async {

      ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);
      CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);

      List<String> webImagesList = [
        "https://images.pexels.com/photos/3015481/pexels-photo-3015481.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/29708087/pexels-photo-29708087.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/2247248/pexels-photo-2247248.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/8171194/pexels-photo-8171194.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/17483869/pexels-photo-17483869.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/29708087/pexels-photo-29708087.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/2247248/pexels-photo-2247248.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/8171194/pexels-photo-8171194.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/17483869/pexels-photo-17483869.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/2247248/pexels-photo-2247248.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/8171194/pexels-photo-8171194.jpeg?auto=compress&cs=tinysrgb&h=350",
        "https://images.pexels.com/photos/17483869/pexels-photo-17483869.jpeg?auto=compress&cs=tinysrgb&h=350",
      ];
      // for (var item in checkListProvider.listFinalContent) {
      //     String topic = title + ' : '+ item.name;

      //     if (topic != null && topic.isNotEmpty) {
      //         String webImages = await WebImagesProvider().getPhotos(topic);
      //         webImagesList.add(webImages);
      //     }
      // }
      researchImageProvider.setWebImages(webImagesList);

  }

  loadAIImages (BuildContext context, String title, String selectedTopic) async {

      ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);
      CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
      List<String> aiImagesList = [
        "https://image.lexica.art/full_jpg/0109beee-4709-4d9a-8e7f-6fd37626844f",
        "https://image.lexica.art/full_jpg/05a4bc9d-0550-46ec-bf1a-72e4e82bbe27",
        "https://image.lexica.art/full_jpg/0a86b674-58b1-4e04-be25-0b82a47134d0",
        "https://thumbs.dreamstime.com/b/local-market-farmer-selling-vegetables-produce-his-stall-awning-modern-flat-style-realistic-vector-illustration-isolated-69723395.jpg",
        "https://thumbs.dreamstime.com/b/local-market-farmer-selling-vegetables-produce-his-stall-awning-modern-flat-style-realistic-vector-illustration-isolated-69723395.jpg",
        "https://thumbs.dreamstime.com/b/local-market-farmer-selling-vegetables-produce-his-stall-awning-modern-flat-style-realistic-vector-illustration-isolated-69723395.jpg",
        "https://thumbs.dreamstime.com/b/local-market-farmer-selling-vegetables-produce-his-stall-awning-modern-flat-style-realistic-vector-illustration-isolated-69723395.jpg",
        "https://thumbs.dreamstime.com/b/local-market-farmer-selling-vegetables-produce-his-stall-awning-modern-flat-style-realistic-vector-illustration-isolated-69723395.jpg",
        "https://thumbs.dreamstime.com/b/local-market-farmer-selling-vegetables-produce-his-stall-awning-modern-flat-style-realistic-vector-illustration-isolated-69723395.jpg",
      ];
      // for (var item in checkListProvider.listFinalContent) {
      //     String topic = title + ' : '+ item.name;

      //     String webImages = await RapidAiImageHandler().getAIImage(topic);
      //     aiImagesList.add(webImages);
      // }
      researchImageProvider.setAIImages(aiImagesList);

  }

  getWebImages (BuildContext context, String prompt) async {

      ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);
      List<String> webImagesList = [ ];
  
      if (prompt != null && prompt.isNotEmpty) {
          webImagesList = await WebImagesHandler().getPhotosList(prompt);
      }
      researchImageProvider.setWebImages(webImagesList);

  }

  getAIImage (BuildContext context, String prompt) async {

      ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);
      
      List<String> aiImagesList = [ ];
      
      aiImagesList = await RapidAiImageHandler().getAIImage(prompt);
      

      // String webImages = await RapidAiImageHandler().getAIImage(prompt);
      // aiImagesList.add(webImages);
      
      researchImageProvider.setAIImages(aiImagesList);

  }

}
