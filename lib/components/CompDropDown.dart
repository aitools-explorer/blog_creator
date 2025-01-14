import 'package:blog_creator/components/UtilsComponent.dart';
import 'package:flutter/material.dart';

class CompDropDown {


    

  static Widget dropDown({
    required BuildContext context,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    String? hint = 'Choose ',
  }) {
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
          value: value,
          items: items.map((itemName) => DropdownMenuItemComp(itemName)).toList(),
          onChanged: onChanged,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Text(hint!, style: const TextStyle(color: Colors.white)),
            ),
          ),
          underline: Container(),
          dropdownColor: Colors.blueAccent,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          iconEnabledColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }

  
}

