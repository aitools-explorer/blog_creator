
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfWidgets {


  static getHeader(String title, String topic, pw.Font font) {
    return pw.Column(children: [
          PdfWidgets.getTitleWidget(title, font),
          pw.SizedBox(height: 10),

          PdfWidgets.getTopicWidget(topic, font),
          pw.SizedBox(height: 14),
        ]);
  }
  


  static pw.Widget getTitleWidget(String title, pw.Font font) {
    return pw.Center(
      child: pw.Text( title, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#1b1919'), font: font) ),
    );
  }


  static pw.Widget getTopicWidget(String topic, pw.Font font) {
    return pw.Center(
      child: pw.Text(
        topic,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromHex('#342c2c'),
          font: font,
        ),
      ),
    );
  }

  static pw.Column getNameWidget(String name, pw.Font font) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text( name, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold,color: PdfColor.fromHex('#474040'), font: font ) ,maxLines: null, ),
      pw.SizedBox(height: 8),
      pw.SizedBox(height: 4),
    ]);
  }


  static pw.Widget getImageWidget(String imageUrls, Uint8List imageBytes) {
    if(imageUrls.isNotEmpty)
      return pw.Image(pw.MemoryImage(imageBytes.buffer.asUint8List(),), height: 100, width: 150,  );
    else
      return pw.Container();
  }

  static getContentWidget(String content, pw.Font font) {
    return  pw.Column(
        mainAxisSize: pw.MainAxisSize.max,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text(
            content,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal, color: PdfColor.fromHex('#545151'), font: font),
            maxLines: null,
          ),
        ],
      );
  }

  static pw.Column getTabularDataWidget(String tabularData, pw.Font fontCourier) {
      return pw.Column(children: [
        pw.SizedBox(height: 12),
        if (tabularData.isNotEmpty)
          pw.Container(
            width: double.infinity,
            alignment: pw.Alignment.centerLeft,
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2.0),
              child: pw.Text(
                tabularData,
                style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex('#545151'), font: fontCourier), // change this font
                textAlign: pw.TextAlign.left,
              ),
            ),
          ),
      ]);
  }



}