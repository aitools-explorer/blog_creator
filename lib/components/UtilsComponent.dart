import 'package:flutter/material.dart';

  DropdownMenuItem<String> DropdownMenuItemComp(String value) {
    return DropdownMenuItem<String>(
      child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(value,  style: TextStyle(color: Colors.white),),
            ),
      value: value,
    );
  }