import 'dart:convert';

import 'package:blog_creator/Authoring.dart';
import 'package:blog_creator/Network/NetworkConst.dart';
import 'package:blog_creator/Provider/ButtonProvider.dart';
import 'package:blog_creator/Provider/CheckboxProvider.dart';
import 'package:blog_creator/Provider/Loaderprovider.dart';
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
    ChangeNotifierProvider(create: (_) => LoaderProvider()),
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

String base64Encode(String input) {

  List<int> bytes = utf8.encode(input);
  String base64String = Base64Encoder().convert(bytes);
  
  return base64String;
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
    // print(base64Encode("ZjY45kZSxSjvH2GWbNBKh5FN8tzYGdTqxVDs2SRtMpcp1hc2YyFa9WXr"));
    

    // print(NetworkConst.base64Decode('c2stcHJvai1CUzJ0SVYtYVFKMmFCbnVWOUM3TWhFQ0tqbmpRbzY4UVZNNUoycUtIb2h2Z0xJd3JLVlgtdVRXZ003ZC1PSFRjTHFBT2dvQllUM1QzQmxia0ZKNnhyaUtCaHVkeXV3VzhWaks4Q0tncEYwS21pME5PcTJNYTRya0MzOFJPTWRpZDNlU2Vmc2lNMHViSlVTR3FqNUljZ3o1QXg2NEE='));



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cognify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Consumer<NavigationProvider>(
            builder: (context, navigationProvider, child) {
              return Text(
                navigationProvider.getTitle(),
                textAlign: TextAlign.left,
              );
            },
          ),
          backgroundColor: Color(0xFFF1F5F9), // Light grayish blue
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black), // Black menu icon
        ),

        drawer: CognifyDrawer(),
        
        
        body: Stack(
          children: [
            
            Consumer<NavigationProvider>(
                builder: (context, homePageProvider, child) {
                  return IndexedStack(
                    index: homePageProvider.pageIndex,
                    children: [
                      HomePage(),
                      SelectTopic(),
                      Research(),
                      ResearchImage(),
                      Authoring(),
                      ReviewScreen(),
                      Text("default")
                    ],
                  );
                },
              ),   
              Consumer<LoaderProvider>(builder: (context, loaderProvider, child) {
                return loaderProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Text('');
              },),
          ]
        ),
      ),
    );
    
  }
}




