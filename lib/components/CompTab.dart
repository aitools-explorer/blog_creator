import 'package:flutter/material.dart';


class CompTab extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  CompTab({required this.title, required this.onPressed});


@override
  Widget build(BuildContext context) {
    
    return Tab(
      child: Container(
        width: 200,
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Text(title),
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Icon(Icons.close, color: Colors.red, size: 16),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
    
  //   return Tab(
  //     child: Stack(
  //       children: [
  //         Align(
  //           alignment: Alignment.center,
  //           child: Text(title),
  //         ),
  //         Positioned(
  //           right: 0,
  //           top: 0,
  //           child: IconButton(
  //             icon: Icon(Icons.close, color: Colors.red, size: 14),
  //             onPressed: onPressed,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
