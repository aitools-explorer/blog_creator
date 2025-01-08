import 'package:blog_creator/Network/WebImagesHandler.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/CheckboxProvider.dart';
import 'package:blog_creator/Provider/Loaderprovider.dart';
import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:blog_creator/Provider/ResearchDataProvider.dart';
import 'package:blog_creator/Provider/ResearchImageProvider.dart';
import 'package:blog_creator/Provider/ResearchProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Research.dart';
import 'package:blog_creator/components/CompContainer.dart';
import 'package:blog_creator/components/CompTab.dart';
import 'package:blog_creator/components/CompTextField.dart';
import 'package:blog_creator/components/ComponentButton.dart';
import 'package:blog_creator/components/CustomDialog.dart';
import 'package:blog_creator/controller/DataController.dart';
import 'package:blog_creator/controller/ImageController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Research extends StatefulWidget {
  @override
  _ResearchState createState() => _ResearchState();
}

class _ResearchState extends State<Research> with TickerProviderStateMixin {

  late TabController _tabController;
  late TabController _tabImageController;
  late ResearchProvider researchProvider;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _contImage = TextEditingController();
  late LoaderProvider loaderProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    loaderProvider = Provider.of<LoaderProvider>(context, listen: false);
    researchProvider = Provider.of<ResearchProvider>(context, listen: false);
    _tabController = TabController(length: researchProvider.tabs.length, vsync: this);
    _tabImageController = TabController(length: 4, vsync: this);

    return Scaffold(
      backgroundColor:  const Color(0xFFF1F5F9), // Light grayish blue,
      body: DefaultTabController(
            length: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16, top: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Row(
                    children: [
                        Text('${Provider.of<ReviewProvider>(context, listen: false).title} : ',
                          textAlign: TextAlign.center,
                          style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A),),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text( Provider.of<ReviewProvider>(context, listen: false).selectedTopic,
                            style: const TextStyle( fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A), ),
                          ),
                        ),

                        
                        // Checkbox(
                        //     value: Provider.of<CheckboxProvider>(context).hasImage,
                        //     onChanged: (value) {
                        //       ImageController().toggleHasImage(context);
                        //     },
                        // ),
                        // const Text('Add images', style: TextStyle(fontSize: 18, color: Colors.black)),
                    ],
                  ),
                  
                  // Show fact generation view
                  Visibility(
                    visible: !Provider.of<CheckboxProvider>(context).hasImage,
                    child: _factGenerationView(),
                  ),
                 

                ],
              ),
            ),

            ),
    );

  }

  
  // Method to show fact generation view
  Widget _factGenerationView() {

    _tabController.addListener(() {
      researchProvider.setSelectedTabName(researchProvider.tabs[_tabController.index]);
    });

    return Expanded(
      child: Column(
        
        children: [
              Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        // indicator: BoxDecoration(
                        //   borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(16),
                        //     topRight: Radius.circular(16)
                        //   ),
                        //   color: Colors.blue,
                        // ),
                        // indicator: BoxDecoration( color: Colors.blue),
                        tabs: context.watch<ResearchProvider>().tabs.map((tab) {
                          
                          int index = researchProvider.tabs.indexOf(researchProvider.selectedTabName);
                          if (index != -1) {
                            _tabController.index = index;
                          }
                          return CompTab(
                            title: tab,
                            onPressed: () {
                              _removeTab(tab);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () {
                        context.read<ResearchProvider>().addTab('Tab ${context.read<ResearchProvider>().tabs.length + 1}');
                        researchProvider.setSelectedTabName(researchProvider.tabs[_tabController.index]);
                        _tabController = TabController(length: context.read<ResearchProvider>().tabs.length, vsync: this);
                        
                      },
                      tooltip: 'Add new tab',
                    ),
                  ],
              ),
            
              Expanded(
                child: getTabBody(context)
              ),
              
              const SizedBox(height: 12),
              bottomContainer(context)
        ],
      ),
    );

  }

  // Method to remove tab on X button click
  void _removeTab(String tab) {

    ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);
    researchDataProvider.factData.remove(tab);

    
    researchProvider.removeTab(researchProvider.tabs.indexOf(tab));
    _tabController = TabController(length: context.read<ResearchProvider>().tabs.length, vsync: this);
    
  }

  
  Widget getTabBody(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: context.watch<ResearchProvider>().tabs.map((tab) => _createTabBody(context, tab)).toList(),
    );
  }

  
  Widget _createTabBody(BuildContext context, String tab) {
    int tabIndex = researchProvider.tabs.indexOf(tab);
    print('loading body for tab : $tabIndex');

    return Container(
              color: Colors.white,
              child: Padding(
              padding: const EdgeInsets.all(12),
              child: Consumer<ResearchDataProvider>(
                  builder: (context, researchDataProvider, child) {
                
                  List<Modelfact>? listFacts = researchDataProvider.factData[tab];
                  
                  if (listFacts == null) {
                    return const Center(child: Text('Find facts'));
                  }
                  
                  return ListView.builder(
                    itemCount: listFacts?.length,
                    itemBuilder: (context, index) {
              
                      final fact = listFacts?[index];
                      return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
              
                                  Checkbox(
                                    value: fact?.factName != null ? fact!.isSelected : false,
                                    onChanged: (bool? value) {
                                      researchDataProvider.toggleSelection(tab, fact!);
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                          padding: const EdgeInsets.only(top: 6.0),
                                          child: Text(fact?.factName ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ],
                              );
              
                    },
                  );
              
                },
              ),
      )
    );
  }
  


  Widget bottomContainer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        
        Expanded(
          child: CompContainer.getContainer(
            child: TextField(
              controller: _controller,
              decoration: CompTextField.getInputDecorations(hint: 'Add more facts'),
              onSubmitted: (value) {
                  getFacts(context, value);
              },
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        ComponentButton(title: 'Add more facts', onTap: () {
            getFacts(context, _controller.text);
        },),
        
        const SizedBox(width: 16),
        
        ComponentButton(title: 'Back', onTap: () {
          NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
            homePageProvider.setPage(1);
        },),
        
        const SizedBox(width: 16),
        
        ComponentButton(
         title: 'Research Images',
         onTap: () async {

            NavigationProvider homePageProvider = Provider.of<NavigationProvider>(context, listen: false);
            homePageProvider.setPage(3);
        
        }),
        
        
      ],
    );
  }

  
  void getFacts(BuildContext context, String text) {
    
      if (text.isNotEmpty) {
                  
          String blogTitle = Provider.of<ReviewProvider>(context, listen: false).title;
          String blogTopic = Provider.of<ReviewProvider>(context, listen: false).selectedTopic;
          ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);   

          researchProvider.tabs[_tabController.index] = text;
          researchProvider.notify();
          loaderProvider.setLoading(true);
          DataController().getFacts(context, researchProvider.tabs[_tabController.index], blogTitle, blogTopic, text).then((value) {
              loaderProvider.setLoading(false);
              if (value) {
                print('======> $value');
                // CheckListProvider().notify();
                _controller.clear();

              } else {
                  CustomDialog().showCustomDialog(context, 'Error', 'Failed to fetch fact details. Please try again.');
              }
          });
      }
    
  }
  
}
