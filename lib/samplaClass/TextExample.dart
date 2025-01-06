import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class TextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = 'Hello, World!: This is a sample text.\nConclussion in bold: This should be normal text';
    final regex = RegExp(r'(?<=\n).*:(.*)');

    return Text.rich(
      TextSpan(
        children: [
          for (var line in text.split('\n'))
            TextSpan(
              text: line.replaceAllMapped(regex, (match) => '\n${match.group(0)}\n'),
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: line.contains(':') ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
} 