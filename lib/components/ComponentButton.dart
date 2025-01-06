import 'package:flutter/material.dart';

class ComponentButton extends StatelessWidget {
  final String title;
  final double? width;
  final Function()? onTap;
  Alignment alignment = Alignment.centerLeft;

  ComponentButton( {required this.title, this.width, required this.onTap, this.alignment = Alignment.center} );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 120, // Fixed width
        height: 40,
        padding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF459aff), Color(0xFF6054ff)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white, // Text color for better contrast
            ),
          ),
        ),
      ),
    );
  }
}
