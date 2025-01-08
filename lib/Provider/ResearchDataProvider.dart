import 'package:flutter/material.dart';

class Modelfact {
  String factName;
  bool isSelected;

  Modelfact({required this.factName, bool? isSelected}) : isSelected = isSelected ?? false;

  void toggleSelection() {
    isSelected = !isSelected;
  }
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

  void reset() {
    _factData.clear();
    notifyListeners();
  }


  void notify() {
    notifyListeners();
  }

}
