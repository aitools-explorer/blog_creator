import 'dart:convert';

import 'package:blog_creator/Model/ModelFile.dart';
import 'package:flutter/material.dart';

class Modelfact {
  String factName;
  bool isSelected;

  Modelfact({required this.factName, bool? isSelected}) : isSelected = isSelected ?? false;

  void toggleSelection() {
    isSelected = !isSelected;
  }

  @override
  String toString() {
    return 'Modelfact(factName: $factName, isSelected: $isSelected)';
  }

  static ResearchData fromJson(Map<String, dynamic> map) {

    print('ResearchData.fromJson: ${map['facts']}');
    
    return map['facts'] == null
        ? ResearchData(facts: {})
        : ResearchData(
            facts: Map<String, List<Modelfact>>.from(
                Map<String, dynamic>.from(map['facts'] as Map<String, dynamic>).map((key, value) => 
                    MapEntry(key, (value as List<dynamic>).map((fact) => Modelfact.fromJsons(Map<String, dynamic>.from(fact))).toList()))));
  }

  
  factory Modelfact.fromJsons(Map<String, dynamic> json) => Modelfact(
        factName: json['factName'],
        isSelected: json['isSelected'],
      );

  Map<String, dynamic> toJson() => {
        'factName': factName,
        'isSelected': isSelected,
  };

  
}

class ResearchDataProvider with ChangeNotifier {
 
  Map<String, List<Modelfact>> _factData = {};

  void toggleSelection(String key, Modelfact fact) {
    if (_factData.containsKey(key)) {
      for (var modelfact in _factData[key]!) {
        if (modelfact.factName == fact.factName) {
          modelfact.toggleSelection();
        }
      }
      notifyListeners();
    }
  }


  void add(String key, Modelfact value) {
    if (!_factData.containsKey(key)) {
      _factData[key] = [];
    }
    _factData[key]!.add(value);
    // notifyListeners();
  }

  void addAll(String key, List<Modelfact> values) {
    if (!_factData.containsKey(key)) {
      _factData[key] = [];
    }
    _factData[key]!.addAll(values);
    notifyListeners();
  }


  void remove(String key, Modelfact value) {
    if (_factData.containsKey(key)) {
      _factData[key]!.remove(value);
      if (_factData[key]!.isEmpty) {
        _factData.remove(key);
      }
    }
    notifyListeners();
  }


  String getSelectedFacts() {
    List<Modelfact> selectedFacts = _factData.values.expand((facts) => facts).where((fact) => fact.isSelected).toList();
    return selectedFacts.map((fact) => fact.factName).join(', ');
  }
            

  Map<String, List<Modelfact>> get factData => _factData;

  
  void setFactData(Map<String, List<Modelfact>> value) {
    _factData = value;
    notifyListeners();
  }

  Map<String, List<Modelfact>> getAllFacts() {
    return _factData;
  }

  String getFactDataInJson() {
    // String factDataJson = '';
    // _factData.forEach((key, facts) {
    //   factDataJson += 'Key: $key\n';
    //   for (var fact in facts) {
    //     factDataJson += '  Fact: ${fact.factName}, Selected: ${fact.isSelected}\n';
    //   }
    // });
    // return factDataJson;

    return jsonEncode(_factData.map((key, facts) => MapEntry(key, facts.map((fact) => {'factName': fact.factName, 'isSelected': fact.isSelected}).toList())));
  }

  void reset() {
    _factData.clear();
    notifyListeners();
  }


  void notify() {
    notifyListeners();
  }

}
