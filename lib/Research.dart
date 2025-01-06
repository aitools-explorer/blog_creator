import 'package:blog_creator/Network/WebImagesHandler.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/Provider/CheckboxProvider.dart';
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
                  
                  
                  // show image generation view
                  Visibility(
                    visible: Provider.of<CheckboxProvider>(context).hasImage,
                    child: _imageGenerationView(),
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
    
            // ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);
            // List<Modelfact> selectedFacts = researchDataProvider.factData.values.expand((facts) => facts).where((fact) => fact.isSelected).toList();
    
            // String concatenatedString = selectedFacts.map((fact) => fact.factName).join(', ');
            // print('Selected fact: ${concatenatedString}');
            // await DataController().getBlogContent(context, concatenatedString);
        
            // CheckListProvider checkListProvider = Provider.of<CheckListProvider>(context, listen: false);
            // // List<ModelBlogData> content = checkListProvider.listSelectedContent
            // //     .where((item) => item.selected)
            // //     .toList();
        
            // checkListProvider.setFinalContent();
        
            // // ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
            
            // // reviewProvider.setOrigContent(content);
            
        
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
          DataController().getFacts(context, researchProvider.tabs[_tabController.index], blogTitle, blogTopic, text).then((value) {
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
  


// Method to show image generation view
  Widget _imageGenerationView() {

    ResearchDataProvider researchDataProvider = Provider.of<ResearchDataProvider>(context, listen: false);
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [


              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const Text('Selected Facts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: researchDataProvider.factData.values.expand((facts) => facts).where((fact) => fact.isSelected).toList().isEmpty ?
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text('No facts selected, Please add some facts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xFFA8A8A8))),
                      )
                      :
                      ListView.builder(
                        itemCount: researchDataProvider.factData.values.expand((facts) => facts).where((fact) => fact.isSelected).toList().length,
                        itemBuilder: (context, index) {
                          Modelfact selectedFact = researchDataProvider.factData.values.expand((facts) => facts).where((fact) => fact.isSelected).toList()[index];
                          return ListTile(
                            title: Text(selectedFact.factName),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              
              VerticalDivider(
                color: Colors.grey,
                thickness: 1,
              ),


              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text('Selected Images', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _showSelectedImages(context),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              VerticalDivider(
                color: Colors.grey,
                thickness: 1,
              ),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: getTab(context)),
                
                    Row(
                      children: [
                
                        Expanded(
                          child: CompContainer.getContainer(
                            child: TextField(
                              controller: _controller,
                              decoration: CompTextField.getInputDecorations(hint: 'What’s on your mind?...'),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                    // Add your logic here
                                    getImage( value);
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),
                        ComponentButton(
                          title: 'Generate Image',
                          onTap: () {
                              getImage(_contImage.text);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),


          ]
        ));
    
  }
  Widget getTab(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabImageController,
            tabs: const [
              Tab(text: 'Web'),
              Tab(text: 'AI'),
              Tab(text: 'Stats'),
              Tab(text: 'Table'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabImageController,
              children: [
                _buildImageFromWeb(context),
                _buildImageFromAi(context),
                _buildImageStats(context),
                _buildTabularData(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildImageFromWeb(BuildContext buildContext) {


    return Consumer<ResearchImageProvider>(
      builder: (context, researchImageProvider, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: researchImageProvider.webImages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                researchImageProvider.toggleWebImageSelection(researchImageProvider.webImages[index].imageUrl);
                if (researchImageProvider.webImages[index].isSelected) {
                  researchImageProvider.addImageFromSelectedList(researchImageProvider.webImages[index].imageUrl);
                } else {
                  researchImageProvider.removeImageFromSelectedList(researchImageProvider.webImages[index].imageUrl);
                }

              },
              child: Container(
                
                decoration: BoxDecoration(
                  border: researchImageProvider.webImages[index].isSelected
                      ? Border.all(width: 2, color: Colors.blue)
                      : null,
                ),
                child: Image.network(
                  researchImageProvider.webImages[index].imageUrl,
                  width: 200,
                  height: 200,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageFromAi(BuildContext context) {

      
      
      return Consumer<ResearchImageProvider>(
        builder: (context, researchImageProvider, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: researchImageProvider.aiImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  
                  researchImageProvider.toggleAiImageSelection(researchImageProvider.aiImages[index].imageUrl);
                  if (researchImageProvider.aiImages[index].isSelected) {
                    researchImageProvider.addImageFromSelectedList(researchImageProvider.aiImages[index].imageUrl);
                  } else {
                    researchImageProvider.removeImageFromSelectedList(researchImageProvider.aiImages[index].imageUrl);
                  }

                },
                child: Container(
                  width: double.minPositive,
                  decoration: BoxDecoration(
                    border: researchImageProvider.aiImages[index].isSelected
                        ? Border.all(width: 2, color: Colors.blue)
                        : null,
                  ),
                  child: Image.network(
                    researchImageProvider.aiImages[index].imageUrl,
                    width: 200,
                    height: 200,
                  ),
                ),
              );
            },
          );
        },
      );
  }

  Widget _buildImageStats(BuildContext context) {
    return Consumer<ResearchImageProvider>(
      builder: (context, researchImageProvider, child) {
        if (researchImageProvider.modelStats.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text('No stats available', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xFFA8A8A8))),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: researchImageProvider.modelStats.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    researchImageProvider.toggleModelStatsSelection(index);
                    if (researchImageProvider.modelStats[index].isSelected) {
                      researchImageProvider.addImageFromSelectedList(researchImageProvider.modelStats[index].url);
                    } else {
                      researchImageProvider.removeImageFromSelectedList(researchImageProvider.modelStats[index].url);
                    }
                  },
                  child: Container(
                    width: 400,
                    height: 200,
                    decoration: BoxDecoration(
                      border: researchImageProvider.modelStats[index].isSelected
                          ? Border.all(width: 2, color: Colors.blue)
                          : null,
                    ),
                    child: Image.network(
                      researchImageProvider.modelStats[index].url,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  child: DropdownButton<ChartType>(
                    value: ChartType.values.firstWhere((element) => element.name == researchImageProvider.modelStats[index].type),
                    onChanged: (ChartType? newValue) {
                      
                      // researchImageProvider.modelStats[index].type = newValue!.name;
                      DataController().getStatImage(context, researchImageProvider.modelStats[index].stats, newValue!.name);
                      // researchImageProvider.notify();
                    },
                    // items: const [
                    //   DropdownMenuItem<ChartType>(
                    //     value: ChartType.BAR,
                    //     child: Text('Bar Chart'),
                    //   ),
                    //   DropdownMenuItem<ChartType>(
                    //     value: ChartType.LINE,
                    //     child: Text('Line Chart'),
                    //   ),
                    //   DropdownMenuItem<ChartType>(
                    //     value: ChartType.PIE,
                    //     child: Text('Pie Chart'),
                    //   ),
                    // ],

                    items: ChartType.values.map<DropdownMenuItem<ChartType>>((ChartType type) {
                      return DropdownMenuItem<ChartType>(
                        value: type,
                        child: Text(type.toString().split('.').last.toUpperCase() + ' Chart'),
                      );
                    }).toList()
                  ),
                ),
            
              ],
            );
          },
        );
      },
    );
  }

  Widget _showSelectedImages(BuildContext context) {
    return Expanded(
      child: Consumer<ResearchImageProvider>(
        builder: (context, researchImageProvider, child) {
          if (researchImageProvider.selectedImages.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text('Select some images', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xFFA8A8A8))),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: researchImageProvider.selectedImages.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                child: Stack(
                  children: [
                    researchImageProvider.selectedImages[index].contains('|')
                        ? Text( researchImageProvider.selectedImages[index], style: const TextStyle(fontSize: 6) )
                        : Image.network(
                            researchImageProvider.selectedImages[index],
                            width: 200,
                            height: 200,
                          ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          researchImageProvider.removeImageFromSelectedList(researchImageProvider.selectedImages[index]);
                        },
                        child: const Icon(Icons.remove_circle, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  getImage(String prompt) async {

      if (_tabImageController.index == 0) {
        await ImageController().getWebImages(context, prompt);
      } else if (_tabImageController.index == 1) {
        await ImageController().getAIImage(context, prompt);
      } else if (_tabImageController.index == 2) {
        await DataController().getStatsData(context, prompt);
      } else {
        await DataController().getDataTableData(context, prompt);
      }

  }

  _buildTabularData(BuildContext context) {
    return Consumer<ResearchImageProvider>(
      builder: (context, researchImageProvider, child) {

        return ListView.builder(
          itemCount: researchImageProvider.modelTable.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    researchImageProvider.toggleModelTableSelection(index);
                    if (researchImageProvider.modelTable[index].isSelected) {
                      researchImageProvider.addImageFromSelectedList(researchImageProvider.modelTable[index].url);
                    } else {
                      researchImageProvider.removeImageFromSelectedList(researchImageProvider.modelTable[index].url);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: researchImageProvider.modelTable[index].isSelected
                          ? Border.all(width: 2, color: Colors.blue)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${researchImageProvider.modelTable[index].url}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'CourierPrime',
                        ),
                      ),
                      ),
                    ),
                  ),
                
              ],
            );
          },
        );
      },
    );
  }

  

}
