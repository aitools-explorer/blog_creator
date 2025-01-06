import 'package:blog_creator/Provider/ResearchProvider.dart';
import 'package:blog_creator/Provider/ReviewProvider.dart';
import 'package:blog_creator/Research.dart';
import 'package:blog_creator/components/CompTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DynamicTabBar extends StatefulWidget {
  @override
  _DynamicTabBarState createState() => _DynamicTabBarState();
}

class _DynamicTabBarState extends State<DynamicTabBar> with TickerProviderStateMixin {

  // List<String> _tabs = ['Tab 1', 'Tab 2'];
  late TabController _tabController;
  late ResearchProvider researchProvider;

  @override
  void initState() {
    super.initState();
    researchProvider = Provider.of<ResearchProvider>(context, listen: false);
    _tabController = TabController(length: researchProvider.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AppBar(
                bottom: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: context.watch<ResearchProvider>().tabs.map((tab) {
                
                    return CompTab(
                      title: tab,
                      onPressed: () {
                        _removeTab(researchProvider.tabs.indexOf(tab));
                      },
                    );
                
                  }).toList(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: () {
                // Add new tab on + button click
                context.read<ResearchProvider>().addTab('New Tab ${context.read<ResearchProvider>().tabs.length + 1}');
                _tabController = TabController(length: context.read<ResearchProvider>().tabs.length, vsync: this);
              },
              tooltip: 'Add new tab',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: getTabBody(context),
          ),
          Container(
            height: 50,
            color: Colors.grey,
            child: Center(child: Text('Bottom')),
          ),
        ],
      ),
    );
  }

  // Method to remove tab on X button click
  void _removeTab(int index) {
    researchProvider.removeTab(index);
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
    return Center(child: Text(tab));
  }
}
