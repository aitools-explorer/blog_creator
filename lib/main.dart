import 'package:blog_creator/Authoring.dart';
import 'package:blog_creator/Provider/ButtonProvider.dart';
import 'package:blog_creator/Provider/CheckboxProvider.dart';
import 'package:blog_creator/Provider/ResearchDataProvider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';
import 'package:blog_creator/Provider/ResearchProvider.dart';
import 'package:blog_creator/Research.dart';
import 'package:blog_creator/HomePage.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/ResearchImage.dart';
import 'package:blog_creator/ReviewScreen.dart';
import 'package:blog_creator/SelectTopic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CognifyDrawer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // runApp(CognifyApp());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => CheckListProvider()),
    ChangeNotifierProvider(create: (_) => ReviewProvider()),
    ChangeNotifierProvider(create: (_) => ResearchProvider()),
    ChangeNotifierProvider(create: (_) => ResearchDataProvider()),
    ChangeNotifierProvider(create: (_) => CheckboxProvider()),
    ChangeNotifierProvider(create: (_) => ResearchImageProvider()),
    ChangeNotifierProvider(create: (_) => ButtonProvider()),

  ], child: CognifyApp()));
}

class CognifyApp extends StatelessWidget {

  initializeApp() async {
    
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  }
  @override
  Widget build(BuildContext context) {
    
    // initializeApp();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cognify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          // title: Text("Cognify"),
          backgroundColor: Color(0xFFF1F5F9), // Light grayish blue
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black), // Black menu icon
        ),

        drawer: CognifyDrawer(),
        
        
        body: Consumer<NavigationProvider>(
          builder: (context, homePageProvider, child) {
        
            switch (homePageProvider.pageIndex) {
              case 0:
                return HomePage();
              case 1:
                return SelectTopic();
              case 2:
                return Research();
              case 3:
                return ResearchImage();
              case 4:
                return Authoring();
              case 5:
                return ReviewScreen();
              default:
                return Text("default");
            }
          },
        ),
      ),
    );
  }
}




