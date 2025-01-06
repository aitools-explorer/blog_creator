import 'dart:typed_data';

import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Provider/CheckListProvider.dart';
import 'package:blog_creator/components/CompTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DragAndDropView extends StatefulWidget { 
  @override
  _DragAndDropViewState createState() => _DragAndDropViewState();
}

class _DragAndDropViewState extends State<DragAndDropView> {
  List<String> _selectedImages = [];

  List<String> _imageUrls = [
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/301',
    'https://picsum.photos/200/302',
  ];

  @override
  Widget build(BuildContext context) {
    final checkListProvider = Provider.of<CheckListProvider>(context);

    // Add some sample data to checkListProvider.listFinalContent
    if (checkListProvider.listFinalContent.isEmpty) {
      checkListProvider.addContent('Title 1', 'Content 1', '', Uint8List.fromList([]), isSelected: true);
      checkListProvider.addContent('Title 2', 'Content 2', '', Uint8List.fromList([]),  isSelected: true);
      checkListProvider.addContent('Title 3', 'Content 3', '', Uint8List.fromList([]),  isSelected: true);

    
      // checkListProvider.setFinalContent();
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: DragTarget<String>(
              onAcceptWithDetails: (details) {
                setState(() {
                  _selectedImages.add(details.data);
                });
              },
              builder: (context, candidates, rejected) {
                return ListView.builder(
                  itemCount: checkListProvider.listFinalContent.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CompTextField.getEditText(
                          controller: TextEditingController(text: checkListProvider.listFinalContent[index].name),
                          hint: 'Title',
                          onChanged: (value) {
                            checkListProvider.listFinalContent[index].name = value;
                          },
                        ),
                        CompTextField.getEditText(
                          controller: TextEditingController(text: checkListProvider.listFinalContent[index].content),
                          hint: 'Content',
                          onChanged: (value) {
                            checkListProvider.listFinalContent[index].content = value;
                          },
                        ),
                        _selectedImages.contains(_imageUrls[index])
                            ? Image.network(_imageUrls[index])
                            : Text(''),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: ListView.builder(
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Image.network(_imageUrls[index]),
                  trailing: Draggable<String>(
                    data: _imageUrls[index],
                    child: Icon(Icons.drag_handle),
                    feedback: Icon(Icons.drag_handle),
                    childWhenDragging: Icon(Icons.drag_handle, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}