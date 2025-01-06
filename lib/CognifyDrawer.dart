import 'package:blog_creator/Provider/NavigationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CognifyDrawer extends StatefulWidget {
  @override
  _CognifyDrawerState createState() => _CognifyDrawerState();
}

class _CognifyDrawerState extends State<CognifyDrawer> {
  // Track the currently selected menu item
  late NavigationProvider _homePageProvider;

  @override
  Widget build(BuildContext context) {

    _homePageProvider = Provider.of<NavigationProvider>(context);

    return Drawer(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFF5F7FB), ), // Background
            child: Row(
              children: [
                Image.asset(
                          'logo.png',
                          height: 36,
                          width: 36,
                          fit: BoxFit.cover,
                        ),
                SizedBox(width: 10),
                const Text(
                  "COGNIFY",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A55C2), // Text color matching blue
                  ),
                ),
              ],
            ),
          ),
          // Drawer Menu
          Consumer<NavigationProvider>(
            builder: (context, homePageProvider, child) {
              return Column(
                children: [
                  _buildMenuItem(
                    index: 0,
                    icon: Icons.input,
                    title: "Input Domain",
                  ),
                  _buildMenuItem(
                    index: 1,
                    icon: Icons.topic,
                    title: "Select Topic",
                  ),
                  _buildMenuItem(
                    index: 2,
                    icon: Icons.fact_check,
                    title: "Research",
                  ),
                  _buildMenuItem(
                    index: 3,
                    icon: Icons.fact_check,
                    title: "Research Image",
                  ),
                  _buildMenuItem(
                    index: 4,
                    icon: Icons.fact_check,
                    title: "Authoring",
                  ),
                  _buildMenuItem(
                    index: 5,
                    icon: Icons.edit,
                    title: "Blog Refine",
                  ),
                ],
              );
            },
          ),
          Spacer(),
          // Profile and Settings
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        backgroundImage: AssetImage('profile.png'), // Replace with actual image path
                        radius: 22,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Andrew Neilson",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Text color matches the design
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFC4C4C4), // Gray for secondary text
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Logout Button/Icon
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5FF), // Light purple background for button
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Color(0xFFB4A1F2), // Light purple icon
                      ),
                      onPressed: () {
                        // Handle logout action
                      },
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem({required int index, required IconData icon, required String title}) {
    
    bool isSelected = _homePageProvider.pageIndex == index;

    print('._buildMenuItem: Log is selected: ${_homePageProvider.pageIndex}  $index');

    
    return ListTile(
      leading: Icon(icon, color: isSelected ? Color(0xFF4A55C2) : Color(0xFFC4C4C4)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Color(0xFF4A55C2) : Color(0xFFC4C4C4),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Color(0xFFEAF0FF) : null, // Highlighted background color
      onTap: () {
        print('Page number is ${index}');
        _homePageProvider.setPage(index);
      },
    );
  }
}