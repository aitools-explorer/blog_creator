import 'dart:typed_data';

import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Provider/ResearchProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blog_creator/Provider/ResearchDataProvider.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';

void main() {
  group('ResearchDataProvider Tests', () {
    late ResearchDataProvider researchDataProvider;
    late ResearchImageProvider researchImageProvider;

    setUp(() {
      researchDataProvider = ResearchDataProvider();
      researchImageProvider = ResearchImageProvider();
    });

    test('reset should clear _factData and notify listeners', () {
      // Assuming _factData is a public field or there's a method to access it
      researchDataProvider.add('sampleKey', Modelfact(factName: 'Sample Fact'));
      expect(researchDataProvider.factData.isNotEmpty, true);

      researchDataProvider.reset();
      expect(researchDataProvider.factData.isEmpty, true);
    });

    test('notify should call notifyListeners', () {
      bool listenerCalled = false;
      researchDataProvider.addListener(() {
        listenerCalled = true;
      });

      researchDataProvider.notify();

      expect(listenerCalled, true);
    });

    test('reset should clear _modelStats, _selectedImages, and deselect all _webImages and _aiImages', () {
      // Assuming _modelStats, _selectedImages, _webImages, and _aiImages are accessible
      researchImageProvider.reset();
      
      expect(researchImageProvider.modelStats.isEmpty, true);
      expect(researchImageProvider.selectedImages.isEmpty, true);
      expect(researchImageProvider.webImages.every((image) => !image.isSelected), true);
      expect(researchImageProvider.aiImages.every((image) => !image.isSelected), true);
    });

    test('notify should call notifyListeners', () {
      bool listenerCalled = false;
      researchImageProvider.addListener(() {
        listenerCalled = true;
      });

      researchImageProvider.notify();

      expect(listenerCalled, true);
    });

  });

  group('ResearchProvider Tests', () {
    late ResearchProvider researchProvider;

    setUp(() {
      researchProvider = ResearchProvider();
    });

    test('reset should clear _tabs and _selectedTabName', () {
      // Assuming _tabs and _selectedTabName are accessible
      researchProvider.addTab('Sample Tab');
      expect(researchProvider.tabs.isNotEmpty, true);
      researchProvider.setSelectedTabName('Sample Tab');
      expect(researchProvider.selectedTabName.isNotEmpty, true);

      researchProvider.reset();
      expect(researchProvider.tabs.length, 1);
      expect(researchProvider.tabs.first, 'Tab 1');
      expect(researchProvider.selectedTabName.isEmpty, true);
    });

    test('notify should call notifyListeners', () {
      bool listenerCalled = false;
      researchProvider.addListener(() {
        listenerCalled = true;
      });

      researchProvider.notify();

      expect(listenerCalled, true);
    });

  });

  group('ReviewProvider Tests', () {
    late ReviewProvider reviewProvider;

    setUp(() {
      reviewProvider = ReviewProvider();
    });

    test('reset should clear _suggestedTopics, _title, _finalTitle, topics, _selectedTopic, _finalSelectedTopic, _selectedLanguage, and _listOrigContent', () {
      // Assuming the fields are accessible
      reviewProvider.setSuggestedTopics(['Sample Content']);
      reviewProvider.setTitle('Sample Title');
      
      reviewProvider.topics.add('Sample Topic');
      reviewProvider.selectTopic('Sample Content');
      reviewProvider.updateLanguage('Sample Language');
      reviewProvider.setOrigContent([ModelBlogData(name: 'Sample Content', content: 'Sample Title', imageUrls: '', imageBytes: Uint8List(0),  tabularData: '', selected: true)]);

      expect(reviewProvider.suggestedTopics.isNotEmpty, true);
      expect(reviewProvider.title.isNotEmpty, true);
      expect(reviewProvider.finalTitle.isNotEmpty, true);
      expect(reviewProvider.topics.isNotEmpty, true);
      expect(reviewProvider.selectedTopic.isNotEmpty, true);
      expect(reviewProvider.finalSelectedTopic.isNotEmpty, true);
      expect(reviewProvider.selectedLanguage.isNotEmpty, true);
      expect(reviewProvider.listOrigContent.isNotEmpty, true);

      reviewProvider.reset();
      expect(reviewProvider.suggestedTopics.isEmpty, true);
      expect(reviewProvider.title.isEmpty, true);
      expect(reviewProvider.finalTitle.isEmpty, true);
      expect(reviewProvider.topics.isEmpty, true);
      expect(reviewProvider.selectedTopic.isEmpty, true);
      expect(reviewProvider.finalSelectedTopic.isEmpty, true);
      expect(reviewProvider.selectedLanguage == 'English', true);
      expect(reviewProvider.listOrigContent.isEmpty, true);
    });

    test('notify should call notifyListeners', () {
      bool listenerCalled = false;
      reviewProvider.addListener(() {
        listenerCalled = true;
      });

      reviewProvider.notify();

      expect(listenerCalled, true);
    });

  });

  
}
