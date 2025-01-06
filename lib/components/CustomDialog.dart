
import 'package:flutter/material.dart';

class CustomDialog {
    Future<void> showCustomDialog(BuildContext context, String title, String content) async {
      return showDialog( context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    

}