// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:blog_creator/HomePage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:blog_creator/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget( HomePage());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }


import 'package:blog_creator/controller/DataController.dart';
import 'package:blog_creator/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_creator/HomePage.dart';

void main() {
  testWidgets('HomePage build method returns a Scaffold widget', (WidgetTester tester) async {
    // Build the HomePage widget
    await tester.pumpWidget(MaterialApp(
      home: CognifyApp(),
    ));

    // Find the Scaffold widget
    final scaffoldFinder = find.byType(Scaffold);

    // Check if the Scaffold widget is found
    expect(scaffoldFinder, findsOneWidget);
  });


}