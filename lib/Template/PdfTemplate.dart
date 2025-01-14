import 'dart:typed_data';
import 'package:blog_creator/Model/ModelBlogData.dart';
import 'package:blog_creator/Template/PdfWidgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';




class PdfTemplate{
  final String title, topic, templateName;
  final List<ModelBlogData> content;
  pw.Font font;

  PdfTemplate({required this.title,required this.topic, required this.templateName, required this.content, required this.font});
 
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    pw.Font fontCourier = await PdfGoogleFonts.courierPrimeRegular();
    double totalHeight = 0;
    double maxHeight = 950; // max page height
    // late pw.Page currentPage;
    Map<String, pw.Column> pageColMap = {};
    

    pw.Column pageCol = PdfWidgets.getHeader(title, topic, font);

    int pageNo = 0;

    int index = 0;
    for (var item in content) {

      double itemHeight = _getItemHeight(item);

      if (totalHeight + itemHeight > maxHeight) {
        
        // Add new page
        pageColMap[pageNo.toString()] = pageCol;
        pageNo++;

        // add current page content in pageColumn
        pageCol = new pw.Column(children: [_getContentWidget(item, fontCourier, index)]);
        totalHeight = itemHeight; // reset total height

      } else {
        pageCol.children.add(_getContentWidget(item, fontCourier, index));
        totalHeight += itemHeight;
      }
      print(' name :   ${item.name}    $totalHeight');
      index++;
    }
    
    pageColMap[pageNo.toString()] = pageCol;
    pageNo++;
    
    for (var entry in pageColMap.entries) {
      pdf.addPage(
        pw.Page(
          build: (context) => entry.value,
        ),
      );
    }
    return await pdf.save();
  }

  double _getCenterItemHeight(ModelBlogData item) {
    double height = 0;
    height += 13; // font size
    height += 10; // font size
    height += 16; // spacing
    height += (item.content.length / 60) * 10; // estimate text height
    if (item.tabularData.isNotEmpty) height += (item.tabularData.length / 120) * 10; // estimate tabular data height
    if (item.imageUrls.isNotEmpty) height += 200; // image height
    return height;
  }
  
  double _getItemHeight(ModelBlogData item) {
    double height = 14 + 10 + (item.content.length / 60) * 10; // font size, spacing and text height
    if (item.imageUrls.isNotEmpty) height += 200; // image height
    if (item.tabularData.isNotEmpty) height += 150; // table height
    return height;
  }
  
  _getContentWidget(ModelBlogData item, pw.Font fontCourier, int index) {
      
      switch (templateName) {
                            
        case 'Simple':
            return _getCenterContentWidget(item, fontCourier);

        case 'Simple Right':
            return _getRightContentWidget(item, fontCourier);
        
        case 'Simple Left':
            return _getLeftContentWidget(item, fontCourier);
        case 'Alternate':
            return _getAlternetContentWidget(item, fontCourier, index);
    
        default:
          return null;
      }
  }

  _getLeftContentWidget(ModelBlogData item, pw.Font fontCourier) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            PdfWidgets.getNameWidget(item.name, font),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                PdfWidgets.getImageWidget(item.imageUrls, item.imageBytes),
                if(item.imageUrls.isNotEmpty) pw.SizedBox(width: 8),
                pw.Expanded(child: PdfWidgets.getContentWidget(item.content, font))
              ],
            ),
            PdfWidgets.getTabularDataWidget(item.tabularData, fontCourier),
            pw.SizedBox(height: 15),
          ],
        );
  }

  _getRightContentWidget(ModelBlogData item, pw.Font fontCourier) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            PdfWidgets.getNameWidget(item.name, font),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Expanded(child: PdfWidgets.getContentWidget(item.content, font)),
                if(item.imageUrls.isNotEmpty) pw.SizedBox(width: 8),
                PdfWidgets.getImageWidget(item.imageUrls, item.imageBytes),
              ],
            ),
            PdfWidgets.getTabularDataWidget(item.tabularData, fontCourier),
            pw.SizedBox(height: 15),
          ],
        );
  }

  _getAlternetContentWidget(ModelBlogData item, pw.Font fontCourier, index) {
      if(index % 2 == 0) {
        return _getLeftContentWidget(item, fontCourier);
    } else {
        return _getRightContentWidget(item, fontCourier);
    }
  }

  pw.Widget _getCenterContentWidget(ModelBlogData item, pw.Font fontCourier) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [

        PdfWidgets.getNameWidget(item.name, font),
        
        PdfWidgets.getImageWidget(item.imageUrls, item.imageBytes),
        if (item.imageUrls.isNotEmpty) pw.SizedBox(width: 14),
        PdfWidgets.getContentWidget(item.content, font),

        PdfWidgets.getTabularDataWidget(item.tabularData, fontCourier),

        pw.SizedBox(height: 15),
      ],
    );
  }

  
}
