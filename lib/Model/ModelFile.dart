import 'dart:convert';
import 'dart:typed_data';

import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Provider/ResearchDataProvider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';

class ModelFile {
  final List<ModelBlogData> checkList;
  final Review? review;
  final Research? research;
  final ResearchData? researchData;
  final ResearchImage? researchImage;

  const ModelFile({
    required this.checkList,
    this.review,
    this.research,
    this.researchData,
    this.researchImage,
  });

  ModelFile copyWith({
    List<ModelBlogData>? checkList,
    Review? review,
    Research? research,
    ResearchData? researchData,
    ResearchImage? researchImage,
  }) {
    return ModelFile(
      checkList: checkList ?? this.checkList,
      review: review ?? this.review,
      research: research ?? this.research,
      researchData: researchData ?? this.researchData,
      researchImage: researchImage ?? this.researchImage,
    );
  }

  Map<String, Object?> toJson() {
    // print('1-----> ${checkList.map((item) => item.toJson()).toList()}\n\n');
    // print('2-----> ${review?.toJson()}\n\n');
    // print('3-----> ${research?.toJson()}\n\n');
    // print('4-----> ${researchData?.toJson()}\n\n');
    // print('5-----> ${researchImage?.toJson()}\n\n');
    String a = {
      "checkList": checkList.map((item) => item.toJson()).toList(),
      "review": review?.toJson(),
      "research": research?.toJson(),
      "researchData": researchData?.toJson(),
      "researchImage": researchImage?.toJson(),
    }.toString();
    

    return {
      "checkList": checkList.map((item) => item.toJson()).toList(),
      "review": review?.toJson(),
      "research": research?.toJson(),
      "researchData": researchData?.toJson(),
      "researchImage": researchImage?.toJson(),
    };
  }

  static ModelFile fromJson(Map<String, dynamic> json) {

    return ModelFile(
      
      checkList: json['checkList'] == null
          ? <ModelBlogData>[] : List<ModelBlogData>.from((json['checkList'] as List<dynamic>).map((item) {
              return ModelBlogData.fromJson(item);
          } )
          ),
      review: json['review'] == null
          ? null
          : Review.fromJson(json['review'] as Map<String, Object?>),
      research: json['research'] == null
          ? null
          : Research.fromJson(json['research'] as Map<String, Object?>),
      researchData: json['researchData'] == null
          ? null
          : ResearchData.fromJson(
              json['researchData'] as Map<String, Object?>),
      researchImage: json['researchImage'] == null
          ? null
          : ResearchImage.fromJson(
              json['researchImage'] as Map<String, Object?>),
    );
  }

  @override
  String toString() {
    return '''ModelFile(
                checkList: $checkList,
                review: ${review.toString()},
                research: ${research.toString()},
                researchData: ${researchData.toString()},
                researchImage: ${researchImage.toString()}
              )''';
  }

  @override
  bool operator ==(Object other) {
    return other is ModelFile &&
        other.runtimeType == runtimeType &&
        other.checkList == checkList &&
        other.review == review &&
        other.research == research &&
        other.researchData == researchData &&
        other.researchImage == researchImage;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      checkList,
      review,
      research,
      researchData,
      researchImage,
    );
  }
}
      
      
class ResearchImage {
final List<String> images;
final List<String> webImages;
final List<String> aiImages;
final List<ModelStats> modelStats;
final List<ModelStats> modelTable;
const ResearchImage({this.images = const [], this.webImages = const [], this.aiImages = const [], this.modelStats = const [], this.modelTable = const [] });
ResearchImage copyWith({List<String>? images, List<String>? webImages, List<String>? aiImages, List<ModelStats>? modelStats, List<ModelStats>? modelTable}){
return ResearchImage(
            images:images ?? this.images,
            webImages:webImages ?? this.webImages,
            aiImages:aiImages ?? this.aiImages,
            modelStats:modelStats ?? this.modelStats,
            modelTable:modelTable ?? this.modelTable
        );
        }
        
Map<String,Object?> toJson(){
    return {
            'images': images,
            'webImages': webImages,
            'aiImages': aiImages,
            'modelStats': modelStats,
            'modelTable': modelTable
    };
}

static ResearchImage fromJson(Map<String , Object?> json){
    return ResearchImage(
            images:json['images'] == null ? [] : json['images'] as List<String>,
            webImages:json['webImages'] == null ? [] : json['webImages'] as List<String>,
            aiImages:json['aiImages'] == null ? [] : json['aiImages'] as List<String>,
            modelStats:json['modelStats'] == null ? [] : (json['modelStats'] as List<dynamic>).map((e) => ModelStats(
              stats: Map<String, dynamic>.from(e['stats'] as Map),
              url: e['url'] as String,
              type: e['type'] as String,
              isSelected: e['isSelected'] as bool,
            )).toList(),
            modelTable:json['modelTable'] == null ? [] : (json['modelTable'] as List<dynamic>).map((e) => ModelStats(
              stats: Map<String, dynamic>.from(e['stats'] as Map),
              url: e['url'] as String,
              type: e['type'] as String,
              isSelected: e['isSelected'] as bool,
            )).toList()
    );
}

@override
String toString(){
    return '''ResearchImage(
                images:$images,
                webImages:$webImages,
                aiImages:$aiImages,
                modelStats:$modelStats,
                modelTable:$modelTable
    ) ''';
}

      
@override
int get hashCode {
    return Object.hash(
                runtimeType,
                images, 
webImages, 
aiImages, 
modelStats, 
modelTable
    );
}
    
}
      
      
class ResearchData {
final Map<String, List<Modelfact>>? facts;
const ResearchData({this.facts });
ResearchData copyWith({Map<String, List<Modelfact>>? facts}){
  return ResearchData( facts:facts ?? this.facts );
}
        
Map<String,Object?> toJson(){
    return {
            'facts': facts?.map((key, value) => MapEntry(key, value.map((fact) {
                            return {
                              "factName": fact.factName,
                              'isSelected': fact.isSelected,
                            };
                    }
                ).toList()))
    };
}

static ResearchData fromJson(Map<String , Object?> json){

    print('ResearchData.fromJson: ${jsonEncode(json)}');

    
    
    return ResearchData(
            facts:json['facts'] == null ? null : 
            Map<String, List<Modelfact>>.from(
                Map<String, dynamic>.from(json['facts'] as Map<String, dynamic>).map((key, value) {
                        return MapEntry(key, (value as List<dynamic>).map((fact) {
                          
                                  return Modelfact(
                                    factName: fact['factName'],
                                    isSelected: fact['isSelected'],
                                  );
                                }).toList());
    
                },
              )));
}

@override
String toString(){
    return '''ResearchData(
                facts:$facts
    ) ''';
}

@override
bool operator ==(Object other){
    return other is ResearchData && 
        other.runtimeType == runtimeType &&
        other.facts == facts;
}
      
@override
int get hashCode {
    return Object.hash(
                runtimeType,
                facts
    );
}
    
}
      
      
class Research {
final List<String>? tabs;
final String? selectedTabName;
const Research({this.tabs , this.selectedTabName });
Research copyWith({List<String>? tabs, String? selectedTabName}){
return Research(
            tabs:tabs ?? this.tabs,
selectedTabName:selectedTabName ?? this.selectedTabName
        );
        }
        
Map<String,Object?> toJson(){
    return {
            'tabs': tabs,
'selectedTabName': selectedTabName
    };
}

static Research fromJson(Map<String , Object?> json){
    return Research(
            tabs:json['tabs'] == null ? null : List<String>.from(json['tabs'] as List<dynamic>),
selectedTabName:json['selectedTabName'] == null ? null : json['selectedTabName'] as String
    );
}

@override
String toString(){
    return '''Research(
                tabs:$tabs,
selectedTabName:$selectedTabName
    ) ''';
}

@override
bool operator ==(Object other){
    return other is Research && 
        other.runtimeType == runtimeType &&
        other.tabs == tabs && 
other.selectedTabName == selectedTabName;
}
      
@override
int get hashCode {
    return Object.hash(
                runtimeType,
                tabs, 
selectedTabName
    );
}
    
}
      
class Review {
  final String? title;
  final String? finalTitle;
  final String? selectedTopic;
  final String? finalSelectedTopic;
  final List<ModelBlogData> listOrigContent;
  final List<ModelBlogData> listFinalContent;
  final List<String> listSuggestedTopics;
  final String? selectedLanguage;
  final String? selectedTemplateName;
  
  const Review({
    this.title,
    this.finalTitle,
    this.selectedTopic,
    this.finalSelectedTopic,
    this.listOrigContent = const [],
    this.listFinalContent = const [],
    this.listSuggestedTopics = const [],
    this.selectedLanguage,
    this.selectedTemplateName
  });
  
  Review copyWith({
    String? title,
    String? finalTitle,
    String? selectedTopic,
    String? finalSelectedTopic,
    List<ModelBlogData>? listOrigContent,
    List<ModelBlogData>? listFinalContent,
    List<String>? listSuggestedTopics,
    String? selectedLanguage,
    String? selectedTemplateName
  }) {
    return Review(
      title: title ?? this.title,
      finalTitle: finalTitle ?? this.finalTitle,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      finalSelectedTopic: finalSelectedTopic ?? this.finalSelectedTopic,
      listOrigContent: listOrigContent ?? this.listOrigContent,
      listFinalContent: listFinalContent ?? this.listFinalContent,
      listSuggestedTopics: listSuggestedTopics ?? this.listSuggestedTopics,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedTemplateName: selectedTemplateName ?? this.selectedTemplateName,
    );
  }
  
  Map<String, Object?> toJson() {
    return {
      'title': title,
      'finalTitle': finalTitle,
      'selectedTopic': selectedTopic,
      'finalSelectedTopic': finalSelectedTopic,
      'listOrigContent': listOrigContent.map((e) => e.toJson()).toList(),
      'listFinalContent': listFinalContent.map((e) => e.toJson()).toList(),
      'listSuggestedTopics': listSuggestedTopics,
      'selectedLanguage': selectedLanguage,
      'selectedTemplateName': selectedTemplateName,
    };
  }
  
  static Review fromJson(Map<String, Object?> json) {
    return Review(
      title: json['title'] as String?,
      finalTitle: json['finalTitle'] as String?,
      selectedTopic: json['selectedTopic'] as String?,
      finalSelectedTopic: json['finalSelectedTopic'] as String?,
      listOrigContent:json['listOrigContent'] == null ? [] : (json['listOrigContent'] as List<dynamic> ).map((row) {

                  print('3--------------> ${row.toString()}');
                  Map<String, dynamic> data = jsonDecode( jsonEncode(row));
                  // print('3-------------->');
                  return ModelBlogData.fromJson(data);
                    // return ModelBlogData(
                    //     name: 'name',
                    //     imageUrls: 'imageUrls',
                    //     imageBytes: Uint8List.fromList([]),
                    //     content: 'content',
                    //     selected: false,
                    //     tabularData: 'tabularData',
                    //   );
        },
      ).toList(),
        listFinalContent:json['listFinalContent'] == null ? [] : (json['listFinalContent'] as List<dynamic>).map((row) {
                      
                    
                    print('4-------------->');
                    Map<String, dynamic> data = jsonDecode( jsonEncode(row));
                    return ModelBlogData.fromJson(data);
          },
        ).toList(),

      listSuggestedTopics: (json['listSuggestedTopics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      selectedLanguage: json['selectedLanguage'] as String?,
      selectedTemplateName: json['selectedTemplateName'] as String?,
    );
    
  }
  
  @override
  String toString() {
    return '''Review(
                title: $title,
                finalTitle: $finalTitle,
                selectedTopic: $selectedTopic,
                finalSelectedTopic: $finalSelectedTopic,
                listOrigContent: $listOrigContent,
                listFinalContent: $listFinalContent,
                listSuggestedTopics: $listSuggestedTopics,
                selectedLanguage: $selectedLanguage,
                selectedTemplateName: $selectedTemplateName
              )''';
  }
  
  @override
  bool operator ==(Object other) {
    return other is Review &&
        other.runtimeType == runtimeType &&
        other.title == title &&
        other.finalTitle == finalTitle &&
        other.selectedTopic == selectedTopic &&
        other.finalSelectedTopic == finalSelectedTopic &&
        other.listOrigContent == listOrigContent &&
        other.listFinalContent == listFinalContent &&
        other.listSuggestedTopics == listSuggestedTopics &&
        other.selectedLanguage == selectedLanguage &&
        other.selectedTemplateName == selectedTemplateName;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      title,
      finalTitle,
      selectedTopic,
      finalSelectedTopic,
      listOrigContent,
      listFinalContent,
      listSuggestedTopics,
      selectedLanguage,
      selectedTemplateName,
    );
  }
}
      
      
  
     