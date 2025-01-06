import 'dart:typed_data';
import 'package:blog_creator/Model/ModeContent.dart';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfSimpleLeftTemplate{
  final String title, topic;
  final List<ModelBlogData> content;
  pw.Font font;

  PdfSimpleLeftTemplate({required this.title,required this.topic, required this.content, required this.font});
 
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
                pw.Center(
                  child: pw.Text( title, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#1b1919'), font: font) ),
                ),
                pw.SizedBox(height: 10),

                pw.Center(
                  child: pw.Text( topic, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#342c2c'), font: font) ),
                ),
                pw.SizedBox(height: 20),

                ...content.map((item) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [

                      pw.Text(
                          item.name,
                          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold,color: PdfColor.fromHex('#474040'), font: font ) ,maxLines: null, ),
                      pw.SizedBox(width: 14),

                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [

                          if(item.imageUrls.isNotEmpty) pw.Image(pw.MemoryImage(item.imageBytes.buffer.asUint8List(),), height: 100, width: 100,  ),
                          if(item.imageUrls.isNotEmpty) pw.SizedBox(width: 8),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  item.content,
                                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal,color: PdfColor.fromHex('#545151'), font: font ) ,maxLines: null, ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 15),
                    ],
                  );
                }).toList(),
                
          ],
        ),
      ),
    );

    return await pdf.save();
  }

  
}