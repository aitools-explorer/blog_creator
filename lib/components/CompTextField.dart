import 'package:flutter/material.dart';

class CompTextField  {
  
  static InputDecoration getInputDecorations({
    String hint = '',
    TextStyle textStyle = const TextStyle(color: Color(0xFFB4B4B4), fontSize: 16),
    InputDecoration writtenInputDecoration = const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    suffixIcon: Icon(Icons.search, color: Color(0xFF4A55C2)),
                  )
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: textStyle,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: writtenInputDecoration.suffixIcon,
    );
  }
  
  Function()? onChanged;
  
  static Widget getEditText({
    required TextEditingController controller,
    String hint = '',
    TextStyle? style = const TextStyle(color: Colors.black),
    onChanged
  }) {
    return TextField(

      style: style,

      // decoration: const InputDecoration(
      //   isDense: true,
      //   contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      //   border: OutlineInputBorder(),
      // ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Color(0xFFB4B4B4))
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 138, 138, 138), fontSize: 14),
      ),
      controller: controller,
      onChanged: onChanged,
    );
  }
}