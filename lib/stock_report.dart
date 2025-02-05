// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fluent_ui/fluent_ui.dart' as fl;
// import 'package:intl/intl.dart';
// import 'package:shree_vimal_mobile_dhule/dbservices.dart';
// import 'package:shree_vimal_mobile_dhule/components/fixed_dropdown.dart';
// import 'package:shree_vimal_mobile_dhule/components/webdatepicker.dart';
// import 'package:shree_vimal_mobile_dhule/dbservices.dart';
// import 'package:shree_vimal_mobile_dhule/modal/stock_report.dart';
// import 'package:excel/excel.dart' as exl;
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';


// class Reports extends StatefulWidget {
//   final String? group, modelID, brandID, appTitle;
//   final DateTime start, end;
//   final int durationIndex;

//   const Reports(this.appTitle, this.group, this.modelID,
//       this.brandID, this.start, this.end, this.durationIndex,
//       {super.key});

//   @override
//   State<Reports> createState() => _ReportsState();
// }

// class _ReportsState extends State<Reports> {
//   List<int> xdata = [];
//   List<String> xtitleData = [];
//   List<double> ydata = [];
//   var loading = ValueNotifier<bool>(false);
//   var printing = ValueNotifier<bool>(false);
//   bool searchActive = false;
//   List<String> durationData = [
//     'Today',
//     'Yesterday',
//     'This Week',
//     'This Month',
//     'Last Month',
//     'This Quarter',
//     'This Year',
//     'All Time',
//     'Custom Date'
//   ];
//   List<int> selectionIndex = [];
//   List<List> headerData = [];
//   int durationIndex = 6;
//   List<StockReport> stockreportData = [];
//   List<StockReport> tempData = [];
//   List<String> groupData = ['Brand wise', 'Model wise'];
//   DateTime? start, end;
//   TextEditingController groupCnt = TextEditingController(),
//       searchCnt = TextEditingController();
//   double total = 0;
//   String title = '';
//   Timer? _debounce;
//   List<String> searchTypeData = [];
//   List<List<String>> searchFilter = [];
//   int pageIndex = 100;
//   int previousIndex = 0;
//   ScrollController scrollController = new ScrollController();

//   Future<void> exportExcelReport() async {
//     String name = 'Stock Report.xlsx';
//     List<String> headerData = [
//       "No.",
//       "Model",
//       "IMEI No.",
//       "Supplier Name",
//       "Mobile No.",
//       "Purchase No.",
//       "Purchase Date",
//       "Purchase Rate",
//       "Color",
//       "Warranty",
//       "Payment Type",
//       "Box",
//       "Charger",
//       "Bill",
//     ];
//     int rowIndex = 0;
//     List<List<String>> detailsData = stockreportData.map((e) {
//       rowIndex++;
//       return [
//         rowIndex.toString(),
//         '${e.brand} ${e.model}',
//         e.imeiNo.toString(),
//         e.supplierName.toString(),
//         e.supplierMobile.toString(),
//         e.purchaseNo.toString(),
//         DateFormat('dd MMM yy -').format(e.purchaseDate!),
//         e.purchaseRate.toString(),
//         e.colourName.toString(),
//         e.warranty.toString(),
//         e.paymentType.toString(),
//         e.box.toString(),
//         e.charger.toString(),
//         e.bill.toString(),
//       ];
//     }).toList();

//     List<exl.HorizontalAlign> alignData = [
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Right,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//       exl.HorizontalAlign.Left,
//     ];

//     var outputFile = Platform.isWindows
//         ? 'G:/'
//         : (await getApplicationDocumentsDirectory()).path;
//     final excel = exl.Excel.createExcel();
//     final exl.Sheet sheet = excel[excel.getDefaultSheet()!];
//     var cellStyle = exl.CellStyle(
//         horizontalAlign: exl.HorizontalAlign.Center,
//         fontFamily: exl.getFontFamily(exl.FontFamily.Cambria));

//     for (int i = 0; i < detailsData.length; i++) {
//       for (int j = 0; j < headerData.length; j++) {
//         sheet
//             .cell(
//                 exl.CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
//             .value = exl.TextCellValue(detailsData[i][j]);
//         sheet
//             .cell(
//                 exl.CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
//             .cellStyle = cellStyle.copyWith(horizontalAlignVal: alignData[j]);
//       }
//     }

//     for (int i = 0; i < headerData.length; i++) {
//       sheet
//           .cell(exl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
//           .value = exl.TextCellValue(headerData[i]);
//       sheet
//           .cell(exl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
//           .cellStyle = cellStyle;
//       sheet.setColumnAutoFit(i);
//     }

//     var fileBytes = excel.save();
//     File("$outputFile/$name.xlsx")
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(fileBytes!);
//     OpenFilex.open("$outputFile/$name.xlsx");
//   }

//   @override
//   void dispose() {
//     if (_debounce != null) {
//       _debounce!.cancel();
//     }
//     super.dispose();
//   }

//   void pagination() {
//     if ((scrollController.position.pixels >=
//             scrollController.position.maxScrollExtent - 200) &&
//         (pageIndex <= stockreportData.length) &&
//         pageIndex != previousIndex) {
//       previousIndex = pageIndex;
//       setState(() {
//         pageIndex += 100;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(pagination);
//     groupCnt.text = widget.group!;
//     start = widget.start;
//     end = widget.end;
//     durationIndex = widget.durationIndex;

//     loading.value = true;
//     loadData();
//   }

//   updateDuration(bool? forward) async {
//     if (forward == null) {
//       if (durationIndex == 0) {
//         start = DateTime.now();
//         end = start;
//       } else if (durationIndex == 1) {
//         start = DateTime.now().subtract(const Duration(days: 1));
//         end = start;
//       } else if (durationIndex == 2) {
//         start =
//             DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
//         end = start!.add(const Duration(days: 6));
//       } else if (durationIndex == 3) {
//         start = DateTime(DateTime.now().year, DateTime.now().month);
//         end = DateTime(start!.year, start!.month + 1, 1);
//         end = end!.subtract(const Duration(days: 1));
//       } else if (durationIndex == 4) {
//         start = DateTime(DateTime.now().year, DateTime.now().month - 1);
//         end = DateTime(start!.year, start!.month + 1, 1);
//         end = end!.subtract(const Duration(days: 1));
//       } else if (durationIndex == 5) {
//         start = DateTime(DateTime.now().year, DateTime.now().month - 1);
//         end = DateTime(start!.year, start!.month + 3, 1);
//         end = end!.subtract(const Duration(days: 1));
//       } else if (durationIndex == 6) {
//         var a = DateTime.now().month >= 4
//             ? DateTime.now().year
//             : (DateTime.now().year - 1);
//         start = DateTime(a, 4, 1);
//         end = DateTime(a + 1, 3, 31);
//       } else if (durationIndex == 7) {
//         start = DateTime(2000);
//         end = DateTime.now();
//       } else if (durationIndex == 8) {
//         await showDateRangeDailog();
//       }

//       if (durationIndex != 8) {
//         loading.value = true;
//         loadData();
//       }
//     } else {
//       if (durationIndex == 0 || durationIndex == 1) {
//         start = start!.add(Duration(days: forward ? 1 : -1));
//         end = start;
//       } else if (durationIndex == 2) {
//         start = start!.add(Duration(days: forward ? 7 : -7));
//         end = start!.add(const Duration(days: 6));
//       } else if (durationIndex == 3 || durationIndex == 4) {
//         start = DateTime(start!.year, start!.month + (forward ? 1 : -1), 1);
//         end = DateTime(start!.year, start!.month + 1, 1);
//         end = end!.subtract(const Duration(days: 1));
//       } else if (durationIndex == 5) {
//         start = DateTime(start!.year, start!.month + (forward ? 3 : -3));
//         end = DateTime(start!.year, start!.month + 3, 1);
//         end = end!.subtract(const Duration(days: 1));
//       } else if (durationIndex == 6) {
//         start = DateTime(start!.year + (forward ? 1 : -1), 4, 1);
//         end = DateTime(start!.year + 1, 3, 31);
//       }
//       if (![7, 8].contains(durationIndex)) {
//         loading.value = true;
//         loadData();
//       }
//     }
//   }

//   loadData() async {
//     await mysql_class
//         .loadStockReport(
//             groupCnt.text, start!, end!, widget.brandID!, widget.modelID!)
//         .then((value) {
//       loading.value = false;
//       if (mounted) {
//         stockreportData = value;
//         tempData = stockreportData;
//         searchData(searchCnt.text);
//       }
//     });
//   }

//   loaGroupData() {
//     loading.value = true;
//     loadData();
//   }

//   searchData(String searchVal) {
//     if (searchVal != '') {
//       if (groupCnt.text == 'Brand wise') {
//         stockreportData = tempData
//             .where((element) => element.brand!
//                 .toLowerCase()
//                 .contains(searchVal.toLowerCase()))
//             .toList();
//       } else if (groupCnt.text == 'Model wise') {
//         stockreportData = tempData
//             .where((element) => element.model!
//                 .toLowerCase()
//                 .contains(searchVal.toLowerCase()))
//             .toList();
//       } 
//     } else {
//       stockreportData = tempData;
//     }
//     total = 0;
//     for (var val in tempData) {
//       total += val.purchaseRate!;
//     }
//     setState(() {});
//   }

//   showDateFilter() {
//     return showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               insetPadding: const EdgeInsets.symmetric(horizontal: 10),
//               contentPadding: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5)),
//               content: Container(
//                 width: 320,
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   separatorBuilder: (context, index) => const Divider(
//                     height: 1,
//                   ),
//                   scrollDirection: Axis.vertical,
//                   itemCount: durationData.length,
//                   itemBuilder: (context, index) => ListTile(
//                     selected: index == durationIndex,
//                     onTap: () {
//                       durationIndex = index;
//                       updateDuration(null);
//                       if (durationIndex != 8) Navigator.pop(context);
//                     },
//                     dense: true,
//                     title: Text(
//                       durationData[index],
//                       style: GoogleFonts.poppins(
//                           fontSize: 16, fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                 ),
//               ),
//             ));
//   }

//   showDateRangeDailog() {
//     return showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               insetPadding: const EdgeInsets.symmetric(horizontal: 10),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5)),
//               content: Container(
//                 width: 320,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('Select Date Range',
//                         style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w400)),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: WebDatePicker(
//                             dateformat: 'dd-MM-yyyy',
//                             style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w400),
//                             isFluent: true,
//                             onChange: (val) {
//                               start = val;
//                             },
//                             initialDate: start!,
//                           ),
//                         ),
//                         const Text('  -  '),
//                         Expanded(
//                           child: WebDatePicker(
//                             dateformat: 'dd-MM-yyyy',
//                             style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w400),
//                             isFluent: true,
//                             onChange: (val) {
//                               end = val;
//                             },
//                             initialDate: end!,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: FilledButton(
//                               style: FilledButton.styleFrom(
//                                   fixedSize: const Size(double.infinity, 32),
//                                   minimumSize: const Size(double.infinity, 32),
//                                   backgroundColor: Colors.blue.shade800,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5))),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                                 loading.value = true;
//                                 loadData();
//                               },
//                               child: Text(
//                                 'Update',
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 16,
//                                     color: Colors.white70,
//                                     fontWeight: FontWeight.w500),
//                               )),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: OutlinedButton(
//                               style: OutlinedButton.styleFrom(
//                                   fixedSize: const Size(double.infinity, 32),
//                                   minimumSize: const Size(double.infinity, 32),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5))),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 'Cancel',
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 16,
//                                     color: Colors.black54,
//                                     fontWeight: FontWeight.w500),
//                               )),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/bgd_1.jpg'),
//               fit: BoxFit.cover)),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           titleSpacing: 0,
//           iconTheme: const IconThemeData(color: Colors.white70),
//           leading: widget.group != 'Brand wise'
//               ? null
//               : IconButton(
//                   icon: const Icon(Icons.menu),
//                   onPressed: () {
//                     Scaffold.of(context).openDrawer();
//                   },
//                 ),
//           backgroundColor: Colors.blue.shade700,
//           elevation: 1,
//           title: searchActive
//               ? fl.TextFormBox(
//                   autofocus: true,
//                   controller: searchCnt,
//                   style: GoogleFonts.poppins(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   placeholder: ' Search ',
//                   decoration: const BoxDecoration(color: Colors.white70),
//                   placeholderStyle: const TextStyle(fontSize: 16),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   onChanged: (val) {
//                     searchData(val);
//                   },
//                 )
//               : Text(
//                   '${widget.appTitle} (${stockreportData.length})',
//                   style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white.withOpacity(0.8)),
//                 ),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     searchActive = !searchActive;
//                   });
//                 },
//                 icon: Icon(searchActive ? Icons.close : Icons.search)),
//             const SizedBox(width: 10)
//           ],
//           bottom: PreferredSize(
//             preferredSize:
//                 Size.fromHeight(widget.group == 'Brand wise' ? 110 : 90),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ValueListenableBuilder<bool>(
//                       valueListenable: loading,
//                       builder: (context, loading, child) {
//                         return loading
//                             ? const Center(
//                                 heightFactor: 10, child: fl.ProgressBar())
//                             : Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                     IconButton(
//                                         onPressed: durationIndex > 6
//                                             ? null
//                                             : () {
//                                                 updateDuration(false);
//                                               },
//                                         icon: const Icon(
//                                           Icons.arrow_back_ios,
//                                           size: 20,
//                                           color: Colors.white70,
//                                         )),
//                                     Expanded(
//                                       child: ListTile(
//                                         onTap: () {
//                                           showDateFilter();
//                                         },
//                                         dense: true,
//                                         contentPadding: EdgeInsets.zero,
//                                         leading: const Icon(
//                                           Icons.calendar_month,
//                                           color: Colors.white70,
//                                         ),
//                                         title: Text(
//                                             mysql_class.simpleCurreny(total,
//                                                 showSymbol: true),
//                                             maxLines: 1,
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 17,
//                                                 color: Colors.white
//                                                     .withOpacity(0.8),
//                                                 fontWeight: FontWeight.w500)),
//                                         subtitle: Text(
//                                             DateFormat('dd MMM yy -')
//                                                     .format(start!) +
//                                                 DateFormat('dd MMM yy')
//                                                     .format(end!),
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 15,
//                                                 color: Colors.white70,
//                                                 fontWeight: FontWeight.w500)),
//                                       ),
//                                     ),
//                                     IconButton(
//                                         onPressed: durationIndex > 6
//                                             ? null
//                                             : () {
//                                                 updateDuration(true);
//                                               },
//                                         icon: const Icon(
//                                           Icons.arrow_forward_ios,
//                                           size: 20,
//                                           color: Colors.white70,
//                                         )),
//                                   ]);
//                       }),
//                   const SizedBox(height: 3),
//                   if (widget.group == 'Brand wise') ...[
//                     const SizedBox(height: 3),
//                     Row(children: [
//                       SizedBox(
//                         width: 80,
//                         child: Text(
//                           'Group by  ',
//                           style: GoogleFonts.poppins(
//                               color: Colors.white.withOpacity(0.8),
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       Expanded(
//                         child: DropdowFeild(
//                           style: GoogleFonts.poppins(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.blue.shade800),
//                           onChanged: (_) {
//                             loaGroupData();
//                           },
//                           isFluent: true,
//                           controller: groupCnt,
//                           items: List.generate(
//                               groupData.length,
//                               (index) => DropdownFeildItem(
//                                     value: groupData[index],
//                                     onTap: () {},
//                                     child: Text(
//                                       groupData[index],
//                                       style: GoogleFonts.poppins(
//                                           color: Colors.black87,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   )).toList(),
//                         ),
//                       ),
//                     ])
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           controller: scrollController,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListView.separated(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   separatorBuilder: (context, index) => const Divider(
//                         height: 1,
//                         color: Colors.transparent,
//                       ),
//                   itemCount: pageIndex < stockreportData.length
//                       ? pageIndex
//                       : stockreportData.length,
//                   itemBuilder: (context, index) {
//                     return Material(
//                       color: Colors.white70,
//                       child: ListTile(
//                         dense: true,
//                         title: (groupCnt.text == 'Brand wise')
//                             ? Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                         stockreportData[index]
//                                             .brand
//                                             .toString(),
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.blue.shade900,
//                                             fontSize: 16)),
//                                   ),
//                                   const SizedBox(width: 5),
//                                   Text(
//                                       mysql_class.simpleCurreny(
//                                           stockreportData[index].purchaseRate,
//                                           showSymbol: false),
//                                       style: GoogleFonts.roboto(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.green.shade900,
//                                           fontSize: 16)),
//                                 ],
//                               )
//                                 :Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                             stockreportData[index]
//                                                 .model
//                                                 .toString(),
//                                             style: GoogleFonts.poppins(
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.blue.shade900,
//                                                 fontSize: 16)),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Text(
//                                           mysql_class.simpleCurreny(
//                                               stockreportData[index].purchaseRate,
//                                               showSymbol: false),
//                                           style: GoogleFonts.roboto(
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.green.shade900,
//                                               fontSize: 16)),
//                                     ],
//                                   ),
                                
//                         onTap: () {
//                           if (groupCnt.text == 'Brand wise') {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Reports(
//                                         'Stock Report => ${stockreportData[index].brand}',
//                                         'Brand wise',
//                                         stockreportData[index].brand,
//                                         '',
//                                         start!,
//                                         end!,
//                                         durationIndex)));
//                           } else {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Reports(
//                                         'Stock Report => ${stockreportData[index].model}',
//                                         'Model wise',
//                                         widget.modelID,
//                                         stockreportData[index].model,
//                                         start!,
//                                         end!,
//                                         durationIndex)));
//                           }
//                           // } else {
//                           //   Navigator.push(
//                           //       context,
//                           //       MaterialPageRoute(
//                           //           builder: (context) => Stocks_information(
//                           //               groupDetailData[index].id!))).then(
//                           //       (value) {
//                           //     if (value ?? true) {
//                           //       loadData();
//                           //     }
//                           //   });
//                           // }
//                         },
//                       ),
//                     );
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
