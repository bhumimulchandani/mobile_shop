import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:shree_vimal_mobile_dhule/components/pdf_format.dart';

class PdfViewScreen extends StatefulWidget {
  final List? saleData;
  const PdfViewScreen(this.saleData, {super.key});

  @override
  State<PdfViewScreen> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          shadowColor: Colors.black38,
          backgroundColor: Colors.white,
          title: Text('Invoice PDF',
              style: GoogleFonts.notoSans(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 18)),
        ),
        body: PdfPreview(
          canDebug: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          pdfFileName: 'Invoice.pdf',
          build: (format) => generatePDF(widget.saleData!),
        ));
  }
}
