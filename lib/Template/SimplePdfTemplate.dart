import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

class SimplePdfTemplate {
  final String title;
  final List<String> content;

  SimplePdfTemplate({required this.title, required this.content});

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),

            ...content.map((text) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  text,
                  style: pw.TextStyle(fontSize: 14),
                ),
              );
            }).toList(),


          ],
        ),
      ),
    );

    return await pdf.save();
  }
}
