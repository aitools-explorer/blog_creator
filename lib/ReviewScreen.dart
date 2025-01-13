import 'dart:convert';
import 'dart:io';
import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Provider/CheckboxProvider.dart';
import 'package:blog_creator/Provider/Loaderprovider.dart';
import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:blog_creator/Provider/ResearchDataProvider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';
import 'package:blog_creator/Provider/ResearchProvider.dart';
import 'package:blog_creator/Research.dart';
import 'package:blog_creator/Utils/BlogImageProvider.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Utils/FileHandler.dart';
import 'package:blog_creator/components/ComponentButton.dart';
import 'package:blog_creator/Template/PdfSimple.dart';
import 'package:blog_creator/Template/PdfSimpleRight.dart';
import 'package:blog_creator/components/UtilsComponent.dart';
import 'package:blog_creator/Template/PdfSimpleLeft.dart';
import 'package:blog_creator/Template/SimplePdfTemplate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;


import 'dart:typed_data';



class ReviewScreen extends StatelessWidget {

  late ReviewProvider reviewProvider;
  late LoaderProvider loaderProvider;

  @override
  Widget build(BuildContext context) {

    reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    loaderProvider = Provider.of<LoaderProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light grayish blue,
      // backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: Consumer<ReviewProvider>(
      //     builder: (context, provider, child) {
      //       return Text( provider.title, style: const TextStyle(color: Colors.black), );
      //     },
      //   ),
      //   backgroundColor: const Color(0xFFF1F5F9), // Light grayish blue,
      //   elevation: 0,
      //   centerTitle: false,
      //   automaticallyImplyLeading: false,
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[100],
        child: Row(
          children: [


            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      
                              Consumer<ReviewProvider>(
                                builder: (context, provider, child) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    
                                      const SizedBox(height: 14),
                                      Center(
                                          child: Text( provider.finalTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                                      ),
                                      
                                      const SizedBox(height: 10),
                                      Center(
                                          child: Text(
                                            provider.finalSelectedTopic,
                                            style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, ),
                                          ),
                                      ),
                                      const SizedBox(height: 16),
                      
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: provider.listFinalContent.length,
                                        itemBuilder: (context, index) {
                      
                                          switch (provider.selectedTemplateName) {
                                            case 'Simple':
                                              return templateSimple(context, index);
                                            case 'Simple Right':
                                              return templateSimpleRight(context, index);
                                            case 'Simple Left':
                                              return templateSimpleLeft(context, index);
                                            case 'Alternate':
                                              return alternate(context, index);
                                          }
                      
                                        },
                                      ),
                      
                                    ],
                                  );
                                },
                              )
                      
                      
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
                        
            const SizedBox(height: 16),
                        
            Container(
              margin: const EdgeInsets.only(left: 8, right: 16, bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              width: 250,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  ComponentButton(
                    title: 'Back',
                    width: 200,
                    onTap: () {
                        NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                        homePageProvider.setPage(4);
                    },
                  ),
                  const SizedBox(height: 16),

                  ComponentButton(
                    title: 'Regenerate Blog',
                    width: 200,
                    onTap: () {

                      CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
                      checkListProvider.listFinalContent.clear();

                      ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
                      reviewProvider.reset();
                    
                      ResearchProvider researchProvider = Provider.of<ResearchProvider>(context, listen: false);
                      researchProvider.reset();

                      ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);
                      researchDataProvider.reset();

                      ResearchImageProvider researchImageProvider = Provider.of<ResearchImageProvider>(context, listen: false);
                      researchImageProvider.reset();

                      NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
                      homePageProvider.setPage(0);

                    },
                  ),
                  const SizedBox(height: 16),


                  LanguageDropdown(),
                  const SizedBox(height: 16),
                  
                  TemplateDropdown(),
                  
                  const Spacer(),

                  ComponentButton(
                    title: 'Save as Draft',
                    width: 200,
                    onTap: () {
                      // Logic for saving as draft
                      // Example: saving state to a provider or local storage
                      FileHandler.saveToLocalStorage(context);
                    },
                  ),
                        
                  ComponentButton(
                    title: 'Export to PDF',
                    width: 200,
                    onTap: () async {
                        
                          final provider = Provider.of<ReviewProvider>(context, listen: false);
                          Uint8List pdfBytes;
                        
                          loaderProvider.setLoading(true);
                          switch (provider.selectedTemplateName) {
                            
                            case 'Simple':
                               pdfBytes = await PdfSimpleTemplate(title:provider.finalTitle, topic: provider.finalSelectedTopic, content: provider.listFinalContent,  font: await provider.getFont()  ).generatePdf();
                               break;

                            case 'Simple Right':
                               pdfBytes = await PdfSimpleRightTemplate(title:provider.finalTitle, topic: provider.finalSelectedTopic, content: provider.listFinalContent, font: await provider.getFont()).generatePdf();
                               break;
                            
                            case 'Simple Left':
                              print('creating pdf simple left  ${provider.listFinalContent.length}');
                              pdfBytes = await PdfSimpleLeftTemplate(title:provider.finalTitle, topic: provider.finalSelectedTopic, content: provider.listFinalContent, font: await provider.getFont()).generatePdf();
                              break;
                        
                            // case 'Table And Image':
                            //   pdfBytes = await PdfWithTableAndImageTemplate(title:provider.finalTitle, content: provider.paragraphs).generatePdf();
                            //   break;
                              
                            default:
                              return null;
                          }
                          loaderProvider.setLoading(false);
                        
                          // Create a blob and trigger download
                          final blob = html.Blob([pdfBytes], 'application/pdf');
                          final url = html.Url.createObjectUrlFromBlob(blob);
                          final anchor = html.AnchorElement(href: url)
                            ..target = 'blank'
                            ..download = 'blog.pdf'
                            ..click();
                          html.Url.revokeObjectUrl(url);
                        
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayImageBytes(Uint8List imageBytes) {

    if (imageBytes.isNotEmpty) {
      return Image.memory(
        imageBytes,
        width: 250,
        height: 150,
      );
    } else {
      return const Text('');
    }
  }

displayImage(String listImageUrl) {

  if (listImageUrl.isNotEmpty) {
    return Image.network(
      listImageUrl,
      width: 250,
      height: 150,
    );
  } else {
    return const Text('');
  }
  // return FutureBuilder<Uint8List>(
  //       future: BlogImageProvider().getNetworkImage(listImageUrl),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return Image.memory(
  //             snapshot.data!,
  //             width: 250,
  //             height: 250,
  //           );
  //         } else {
  //           return const CircularProgressIndicator();
  //         }
  //       },
  //     );
}


  // Future<void> generatePdf(BuildContext context) async {
  //   final provider = Provider.of<ReviewProvider>(context, listen: false);

  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) => pw.Column(
  //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: [
  //           pw.Text(
  //             provider.title,
  //             style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
  //           ),

  //           pw.SizedBox(height: 16),
            
  //           ...provider.paragraphs.map((text) {
  //             return pw.Padding(
  //               padding: const pw.EdgeInsets.only(bottom: 8),
  //               child: pw.Text(
  //                 text,
  //                 style: const pw.TextStyle(fontSize: 14),
  //               ),
  //             );
  //           }).toList(),
  //         ],
  //       ),
  //     ),
  //   );

  //   // Convert the PDF to bytes
  //   Uint8List pdfBytes = await pdf.save();

  //   // Create a blob and trigger download
  //   final blob = html.Blob([pdfBytes], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..target = 'blank'
  //     ..download = 'fine_dining.pdf'
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  // }

  
  displayBlogContent(String contentItem) {
    return Expanded(
      child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(contentItem.trim(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,  color: Colors.grey[800]) ),
            ),
    );           
  }

  Widget templateSimple(BuildContext context, int index) {

    
    var provider = Provider.of<ReviewProvider>(context);
      return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                    Text(provider.listFinalContent[index].name.replaceAll('#', '').trim(), style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black, ), textAlign: TextAlign.center),
                    const SizedBox(width: 10),
                    
                    if (provider.listFinalContent[index].imageUrls.isNotEmpty)
                      displayImageBytes(provider.listFinalContent[index].imageBytes),
                    // displayImage(provider.listFinalContent[index].imageUrls),
                    if (provider.listFinalContent[index].imageUrls.isNotEmpty)
                      const SizedBox(width: 10),

                    Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(provider.listFinalContent[index].content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,  color: Colors.grey[800]), textAlign: TextAlign.center), 
                    ),

                    const SizedBox(width: 10),
                    if (provider.listFinalContent[index].tabularData.isNotEmpty)
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(provider.listFinalContent[index].tabularData, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,  color: Colors.grey[800], fontFamily: 'CourierPrime'), textAlign: TextAlign.left), 
                        ),
                      ),
                    
                    // displayBlogContent(provider.listFinalContent[index].content),
                    SizedBox(width: 14),
                                    
                  
                ],
              ),
            );
  }


  Widget templateSimpleRight(BuildContext context, int index) {

    
    var provider = Provider.of<ReviewProvider>(context);
      return Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(provider.listFinalContent[index].name.replaceAll('#', '').trim(), style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black, )),
                  const SizedBox(width: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                          // displayBlogContent(provider.listFinalContent[index]),
                          displayBlogContent(provider.listFinalContent[index].content),
                          const SizedBox(width: 8),

                          if (provider.listFinalContent[index].imageUrls.isNotEmpty)  
                            displayImageBytes(provider.listFinalContent[index].imageBytes),
                          // displayImage(provider.listFinalContent[index].imageUrls)
                      
                    ],
                  ),
                  const SizedBox(width: 10),
                  if (provider.listFinalContent[index].tabularData.isNotEmpty)
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(provider.listFinalContent[index].tabularData, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,  color: Colors.grey[800], fontFamily: 'CourierPrime'), textAlign: TextAlign.left), 
                        ),
                      ),
                ],
              ),
            );
  }

  Widget templateSimpleLeft(BuildContext context, int index) {
    
    var provider = Provider.of<ReviewProvider>(context);
      return Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(provider.listFinalContent[index].name.replaceAll('#', '').trim(), style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black, )),
                  const SizedBox(width: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                          // displayImage(provider.listFinalContent[index].imageUrls),
                          if (provider.listFinalContent[index].imageUrls.isNotEmpty)
                            displayImageBytes(provider.listFinalContent[index].imageBytes),

                          if (provider.listFinalContent[index].imageUrls.isNotEmpty)
                            const SizedBox(width: 8),
                          // displayBlogContent(provider.listFinalContent[index]),
                          displayBlogContent(provider.listFinalContent[index].content),
                          
                    ],
                  ),
                  if (provider.listFinalContent[index].tabularData.isNotEmpty)
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(provider.listFinalContent[index].tabularData, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,  color: Colors.grey[800], fontFamily: 'CourierPrime'), textAlign: TextAlign.left), 
                        ),
                      ),
                ],
              ),
            );
  }

  Widget alternate(BuildContext context, int index) {
    
    if(index % 2 == 0) {
        return templateSimpleRight(context, index);
    } else {
        return templateSimpleLeft(context, index); 
    }
  }
  
  
  

}



class LanguageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF459aff), Color(0xFF6054ff)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<String>(
          value: Provider.of<ReviewProvider>(context).selectedLanguage,
          items: Provider.of<ReviewProvider>(context).availableLanguages.map((language) =>
            DropdownMenuItemComp(language)
          ).toList(),
          onChanged: (String? value) async {
              if (value != null) {
                
                LoaderProvider loaderProvider = Provider.of<LoaderProvider>(context, listen: false);
                loaderProvider.setLoading(true);
                await Provider.of<ReviewProvider>(context, listen: false).updateLanguage(value);
                loaderProvider.setLoading(false);
              }
          },
          hint: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Choose Language', style: TextStyle(color: Colors.white)),
          ),
          underline: Container(),
          dropdownColor: Colors.blueAccent,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          iconEnabledColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );

  }
}


class TemplateDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200,
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF459aff), Color(0xFF6054ff)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<String>(
          
          value:  Provider.of<ReviewProvider>(context).selectedTemplateName,
          items: [
            ...Provider.of<ReviewProvider>(context).availableTemplateNames.map((template) => 
            
              DropdownMenuItemComp(template)
            ),
      
      
          ],
          onChanged: (String? value) {
            if (value != null) {
              Provider.of<ReviewProvider>(context, listen: false).updateTemplateName(value);
            }
          },
          hint: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Choose Template', style: TextStyle(color: Colors.white)),
          ),
          underline: Container(),
          dropdownColor: Colors.blueAccent,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          iconEnabledColor: Colors.white,
        ),
      ),
    );
  }
}
