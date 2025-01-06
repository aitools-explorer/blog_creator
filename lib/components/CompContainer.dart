import 'package:flutter/material.dart';

class CompContainer  {
  
  static Container getContainer({
    required Widget child,
    double borderRadius = 16,
    EdgeInsets padding = const EdgeInsets.all(0),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }

  static Container getTextContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 10,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: child,
    );
  }
  
}