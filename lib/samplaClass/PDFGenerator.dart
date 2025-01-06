import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'dart:html' as html;

class PDFGenerator{
  Future<void> createPdf() async {

    final font = await PdfGoogleFonts.notoSansAdlamRegular();
    // final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    // final ttf = pw.Font.ttf(fontData);

    final pdf = pw.Document();
    final image = await networkImage(
      'https://picsum.photos/200/300',
      headers: {'User-Agent': 'Mozilla/5.0'},
    );

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(
              'Hello, World!',
              style: pw.TextStyle(font: font),
            ),
            // pw.SizedBox(height: 20),
            pw.Image(image),
            // pw.SizedBox(height: 20),
            pw.Text( 'This is a sample PDF template.', ),
          ],
        ),
      ),
    );

      final pdfBytes = await pdf.save();
      print('pdfbyte  conversion done');
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'blog.pdf'
        ..click();
      html.Url.revokeObjectUrl(url);
  }
}

// class PDFGenerator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Generator'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await generatePDF();
//           },
//           child: Text('Generate PDF'),
//         ),
//       ),
//     );
//   }

//   Future<void> generatePDF() async {
//     // Create a new PDF document
//     final pdf = pw.Document();

//     // Load an image from assets (make sure the image is in the assets directory)
//     final imageProvider = await _loadImage('assets/sample_img.jpg');

//     // Add a page to the document
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               // Add text to the PDF
//               pw.Text('Hello, Flutter PDF!', style: pw.TextStyle(fontSize: 30)),
//               pw.SizedBox(height: 20),
//               // Add the image
//               pw.Image(imageProvider),
//             ],
//           );
//         },
//       ),
//     );

//     // Get the temporary directory to save the file
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/example.pdf");

//     // Write the PDF to the file
//     await file.writeAsBytes(await pdf.save());

//     print('PDF saved to ${file.path}');
//   }

//   // Load image from assets
//   Future<pw.MemoryImage> _loadImage(String path) async {
//     final img = await rootBundle.load(path);
//     final  list = img.buffer.asUint8List();
//     return pw.MemoryImage(list);
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: PDFGenerator(),
//   ));
// }
