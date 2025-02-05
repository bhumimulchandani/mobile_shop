import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

Future<Uint8List> generatePDF(List saleData) async {
  final logoImg = await imageFromAssetBundle('assets/logo2.webp');
  PdfColor fillColor = PdfColor.fromHex("#ffcdd2");
  PdfColor darkColor = PdfColor.fromHex("#fe0000");

  List<TableColumnWidth> widthData1 = [
    const FixedColumnWidth(35),
    const FlexColumnWidth(1),
    const FlexColumnWidth(0.7),
    const FixedColumnWidth(70),
    const FixedColumnWidth(70),
    const FixedColumnWidth(85)
  ];

  final converter = AmountToWords();

  final pdf = Document();
  pdf.addPage(
    MultiPage(
      pageTheme: PageTheme(
        margin: const EdgeInsets.all(20),
        buildBackground: (context) => Table(
            border: TableBorder.all(color: PdfColors.black),
            columnWidths: widthData1.toList().asMap(),
            children: [
              TableRow(children: [
                SizedBox(height: 690),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
              ])
            ]),
        pageFormat: PdfPageFormat.a4,
      ),
      header: (context) {
        return Container(
            color: PdfColors.white,
            child: Column(children: [
              Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("SALE INVOICE",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ]),
              ]),
              SizedBox(height: 5),
              Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FixedColumnWidth(200),
                  },
                  border: TableBorder.all(color: PdfColors.black, width: 1),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              logoImg == null
                                  ? SizedBox()
                                  : Container(
                                      width: 75,
                                      height: 70,
                                      child:
                                          Image(logoImg, fit: BoxFit.contain),
                                    ),
                              SizedBox(width: 6),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                        'MOBILE\n      Sales & Service',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 2),
                                    Text(
                                        '',
                                        style: const TextStyle(fontSize: 11)),
                                  ]))
                            ]),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Text('GSTIN',
                                //           style: TextStyle(
                                //               fontSize: 10.5,
                                //               fontWeight: FontWeight.bold)),
                                //       Text('GSTIN123433',
                                //           style: const TextStyle(
                                //             fontSize: 10.5,
                                //           )),
                                //     ]),
                                // SizedBox(height: 10),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Contact No:',
                                          style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          '',
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                          )),
                                    ]),
                              ])),
                    ]),
                    TableRow(children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('BILL TO',
                                    style: const TextStyle(fontSize: 10.5)),
                                SizedBox(height: 3),
                                Text(saleData[0]['customername'].toString(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Mobile',
                                                style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                saleData[0]['customernumber']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                )),
                                          ]),
                                    ]),
                              ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Column(children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            Text('Voucher No.',
                                                style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                saleData[0]['voucherno']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                )),
                                          ])),
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            Text('Voucher Date',
                                                style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                saleData[0]['voucherdate']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                )),
                                          ])),
                                    ])),
                          ])),
                    ])
                  ]),
            ]));
      },
      footer: (context) {
        if (context.pageNumber == context.pagesCount) {
          return Container(
            color: PdfColors.white,
            child: Column(children: [
              Table(
                  border: TableBorder.all(color: PdfColors.black),
                  columnWidths: widthData1.toList().asMap(),
                  children: [
                    TableRow(children: [
                      SizedBox(),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text('Gross Amount',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(saleData[0]['salerate'].toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 9.5, fontWeight: FontWeight.bold))),
                    ]),
                    // TableRow(children: [
                    //   SizedBox(),
                    //   Padding(
                    //       padding: const EdgeInsets.all(5),
                    //       child: Text('Discount',
                    //           textAlign: TextAlign.right,
                    //           style: TextStyle(
                    //               fontStyle: FontStyle.italic,
                    //               fontSize: 9.5,
                    //               fontWeight: FontWeight.bold))),
                    //   SizedBox(),
                    //   SizedBox(),
                    //   SizedBox(),
                    //   Padding(
                    //       padding: const EdgeInsets.all(5),
                    //       child: Text(saleData[0]['discount'].toString(),
                    //           textAlign: TextAlign.right,
                    //           style: TextStyle(
                    //               fontSize: 9.5, fontWeight: FontWeight.bold))),
                    // ]),
                    TableRow(
                        decoration: BoxDecoration(color: fillColor),
                        children: [
                          SizedBox(),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('TOTAL',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(),
                          SizedBox(),
                          SizedBox(),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(saleData[0]['salerate'].toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold))),
                        ]),
                  ]),
              // Container(
              //     width: double.infinity,
              //     decoration:
              //         BoxDecoration(border: Border.all(color: PdfColors.black)),
              //     padding: const EdgeInsets.all(5),
              //     child: RichText(
              //         text: TextSpan(
              //             text: 'Total Amount (in Words)\n',
              //             style: const TextStyle(
              //               lineSpacing: 3,
              //               fontSize: 9,
              //             ),
              //             children: [
              //           TextSpan(
              //               text:
              //                   '${converter.convertAmountToWords(12000, ignoreDecimal: true)} Only',
              //               style: TextStyle(
              //                   fontSize: 9.5, fontWeight: FontWeight.bold))
              //         ]))),
              // Table(
              //     columnWidths: {
              //       0: FlexColumnWidth(1),
              //       1: const FlexColumnWidth(1),
              //       2: const FlexColumnWidth(0.6),
              //     },
              //     border: TableBorder.all(color: PdfColors.black),
              //     children: [
              //       TableRow(
              //           verticalAlignment: TableCellVerticalAlignment.top,
              //           children: [
              //             Padding(
              //                 padding: const EdgeInsets.all(5),
              //                 child: RichText(
              //                     text: TextSpan(
              //                         text: 'Terms and Conditions :\n',
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.bold,
              //                           lineSpacing: 4,
              //                           fontSize: 9,
              //                         ),
              //                         children: [
              //                       TextSpan(
              //                           text: '1. terms .../n2.terms 23 ....',
              //                           style: TextStyle(
              //                             fontWeight: FontWeight.normal,
              //                             fontSize: 9.5,
              //                             lineSpacing: 2,
              //                           ))
              //                     ]))),
                          // if (signImg != null)
                          //   Padding(
                          //       padding:
                          //           const EdgeInsets.symmetric(vertical: 3),
                          //       child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           children: [
                          //             Container(
                          //               width: double.infinity,
                          //               height: 50,
                          //               child: signImg != null
                          //                   ? Image(signImg,
                          //                       fit: BoxFit.contain)
                          //                   : SizedBox(),
                          //             ),
                          //             Text(
                          //                 'Authorised Signatory For\n${OnlineDB.firmData[OnlineDB.compid].firmName}',
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                     fontSize: 9.2,
                          //                     fontWeight: FontWeight.bold))
                          //           ]))
                  //       ])
                  // ]),
            ]),
          );
        } else {
          return Text(context.pageNumber.toString());
        }
      },
      build: (context) => [
        Table(
            border: TableBorder.all(color: PdfColors.black),

            //      border: const TableBorder(

            // bottom: BorderSide(color: PdfColors.black),
            // horizontalInside: BorderSide(color: PdfColors.black)),
            columnWidths: widthData1.toList().asMap(),
            children: [
              TableRow(decoration: BoxDecoration(color: fillColor), children: [
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('No.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('ITEMS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('IMEI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('Qty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('Rate',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('Amount',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
              ]),
              TableRow(children: [
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('1',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        '${saleData[0]["brand"]} ${saleData[0]["modelname"]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        '${saleData[0]["imeino1"]}\n${saleData[0]["imeino2"]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('1',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('${saleData[0]["salerate"]}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${saleData[0]["salerate"]}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 9.5, fontWeight: FontWeight.bold))),
              ]),
            ]),
      ],
    ),
  );
  return pdf.save();
}
