import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:intl/intl.dart';
import 'package:shree_vimal_mobile_dhule/components/webdatepicker.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:shree_vimal_mobile_dhule/in_info.dart';
import 'package:shree_vimal_mobile_dhule/modal/transaction_report.dart';
import 'package:excel/excel.dart' as exl;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shree_vimal_mobile_dhule/out_info.dart';

class ReportsSreen extends StatefulWidget {
  final String? modelID;
  final DateTime? start, end;
  const ReportsSreen({this.modelID, this.start, this.end, super.key});

  @override
  State<ReportsSreen> createState() => _ReportsSreenState();
}

class _ReportsSreenState extends State<ReportsSreen> {
  List<int> xdata = [];
  List<String> xtitleData = [];
  List<double> ydata = [];
  var loading = ValueNotifier<bool>(false);
  var printing = ValueNotifier<bool>(false);
  bool searchActive = false;
  List<String> durationData = [
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'Last Month',
    'This Quarter',
    'This Year',
    'All Time',
    'Custom Date'
  ];
  List<int> selectionIndex = [];
  List<List> headerData = [];
  int durationIndex = 6;
  List<TransactionReport> reportData = [];
  List<TransactionReport> tempData = [];
  List<String> groupData = ['Category wise', 'Subcategory wise', 'Detail wise'];
  DateTime? start, end;
  TextEditingController groupCnt = TextEditingController(),
      searchCnt = TextEditingController();
  double total = 0;
  String title = '';
  Timer? _debounce;
  List<String> searchTypeData = [];
  List<List<String>> searchFilter = [];
  int pageIndex = 100;
  int previousIndex = 0;
  ScrollController scrollController = new ScrollController();

  Future<void> exportExcelReport() async {
    String name = 'Transaction Report.xlsx';
    List<String> headerData = [
      "No.",
      "Model",
      "IMEI No.",
      "Supplier Name",
      "Mobile No.",
      "Purchase No.",
      "Purchase Date",
      "Purchase Rate",
      "-",
      "Sale Rate",
      "Diff. Amount",
      "Sale No.",
      "Sale Date",
      "Customer Name",
      "Mobile No.",
      "Color",
      "Warranty",
      "Payment Type",
      "Box",
      "Charger",
      "Bill",
    ];
    int rowIndex = 0;
    List<List<String>> detailsData = reportData.map((e) {
      rowIndex++;
      return [
        rowIndex.toString(),
        '${e.brand} ${e.model}',
        e.imeiNo.toString(),
        e.supplierName.toString(),
        e.supplierMobile.toString(),
        e.purchaseNo.toString(),
        DateFormat('dd MMM yy -').format(e.purchaseDate!),
        e.purchaseRate.toString(),
        '-',
        e.saleRate == 0 ? '' : e.saleRate.toString(),
        e.saleRate == 0 ? '' : e.diffAmt.toString(),
        e.saleRate == 0 ? '' : e.saleNo.toString(),
        e.saleRate == 0 ? '' : DateFormat('dd MMM yy -').format(e.saleDate!),
        e.saleRate == 0 ? '' : e.customerName.toString(),
        e.saleRate == 0 ? '' : e.customerMobile.toString(),
        e.saleRate == 0 ? '' : e.colourName.toString(),
        e.warranty.toString(),
        e.paymentType.toString(),
        e.box.toString(),
        e.charger.toString(),
        e.bill.toString(),
      ];
    }).toList();

    List<exl.HorizontalAlign> alignData = [
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Right,
      exl.HorizontalAlign.Center,
      exl.HorizontalAlign.Right,
      exl.HorizontalAlign.Right,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
      exl.HorizontalAlign.Left,
    ];

    var outputFile = Platform.isWindows
        ? 'G:/'
        : (await getApplicationDocumentsDirectory()).path;
    final excel = exl.Excel.createExcel();
    final exl.Sheet sheet = excel[excel.getDefaultSheet()!];
    var cellStyle = exl.CellStyle(
        horizontalAlign: exl.HorizontalAlign.Center,
        fontFamily: exl.getFontFamily(exl.FontFamily.Cambria));

    for (int i = 0; i < detailsData.length; i++) {
      for (int j = 0; j < headerData.length; j++) {
        sheet
            .cell(
                exl.CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = exl.TextCellValue(detailsData[i][j]);
        sheet
            .cell(
                exl.CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .cellStyle = cellStyle.copyWith(horizontalAlignVal: alignData[j]);
      }
    }

    for (int i = 0; i < headerData.length; i++) {
      sheet
          .cell(exl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = exl.TextCellValue(headerData[i]);
      sheet
          .cell(exl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .cellStyle = cellStyle;
      sheet.setColumnAutoFit(i);
    }

    var fileBytes = excel.save();
    File("$outputFile/$name.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    OpenFilex.open("$outputFile/$name.xlsx");
  }

  @override
  void dispose() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
    super.dispose();
  }

  void pagination() {
    if ((scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) &&
        (pageIndex <= reportData.length) &&
        pageIndex != previousIndex) {
      previousIndex = pageIndex;
      setState(() {
        pageIndex += 100;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(pagination);

    if (widget.start == null || widget.end == null) {
      updateDuration(null);
    } else {
      start = widget.start;
      end = widget.end;
      loadData();
    }
  }

  updateDuration(bool? forward) async {
    if (forward == null) {
      if (durationIndex == 0) {
        start = DateTime.now();
        end = start;
      } else if (durationIndex == 1) {
        start = DateTime.now().subtract(const Duration(days: 1));
        end = start;
      } else if (durationIndex == 2) {
        start =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        end = start!.add(const Duration(days: 6));
      } else if (durationIndex == 3) {
        start = DateTime(DateTime.now().year, DateTime.now().month);
        end = DateTime(start!.year, start!.month + 1, 1);
        end = end!.subtract(const Duration(days: 1));
      } else if (durationIndex == 4) {
        start = DateTime(DateTime.now().year, DateTime.now().month - 1);
        end = DateTime(start!.year, start!.month + 1, 1);
        end = end!.subtract(const Duration(days: 1));
      } else if (durationIndex == 5) {
        start = DateTime(DateTime.now().year, DateTime.now().month - 1);
        end = DateTime(start!.year, start!.month + 3, 1);
        end = end!.subtract(const Duration(days: 1));
      } else if (durationIndex == 6) {
        var a = DateTime.now().month >= 4
            ? DateTime.now().year
            : (DateTime.now().year - 1);
        start = DateTime(a, 4, 1);
        end = DateTime(a + 1, 3, 31);
      } else if (durationIndex == 7) {
        start = DateTime(2000);
        end = DateTime.now();
      } else if (durationIndex == 8) {
        await showDateRangeDailog();
      }

      if (durationIndex != 8) {
        loading.value = true;
        loadData();
      }
    } else {
      if (durationIndex == 0 || durationIndex == 1) {
        start = start!.add(Duration(days: forward ? 1 : -1));
        end = start;
      } else if (durationIndex == 2) {
        start = start!.add(Duration(days: forward ? 7 : -7));
        end = start!.add(const Duration(days: 6));
      } else if (durationIndex == 3 || durationIndex == 4) {
        start = DateTime(start!.year, start!.month + (forward ? 1 : -1), 1);
        end = DateTime(start!.year, start!.month + 1, 1);
        end = end!.subtract(const Duration(days: 1));
      } else if (durationIndex == 5) {
        start = DateTime(start!.year, start!.month + (forward ? 3 : -3));
        end = DateTime(start!.year, start!.month + 3, 1);
        end = end!.subtract(const Duration(days: 1));
      } else if (durationIndex == 6) {
        start = DateTime(start!.year + (forward ? 1 : -1), 4, 1);
        end = DateTime(start!.year + 1, 3, 31);
      }
      if (![7, 8].contains(durationIndex)) {
        loading.value = true;
        loadData();
      }
    }
  }

  loadData() async {
    await mysql_class.loadReport(start!, end!, widget.modelID).then((value) {
      loading.value = false;
      if (mounted) {
        reportData = value;
        tempData = reportData;
        searchData(searchCnt.text);
      }
    });
  }

  loaGroupData() {
    loading.value = true;
    loadData();
  }

  searchData(String searchVal) {
    if (searchVal != '') {
      reportData = tempData
          //purchasedate,saledate
          .where((element) =>
              element.imeiNo!.toLowerCase().contains(searchVal.toLowerCase()) ||
              element.model!.toLowerCase().contains(searchVal.toLowerCase()) ||
              element.brand!.toLowerCase().contains(searchVal.toLowerCase()) ||
              element.colourName!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element.purchaseNo!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element.supplierMobile!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element.purchaseExecutive!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element.saleNo!.toLowerCase().contains(searchVal.toLowerCase()) ||
              element.customerMobile!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element.saleExecutive!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element.customerName!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element.supplierName!
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()))
          .toList();
    } else {
      reportData = tempData;
    }
    total = 0;
    for (var val in tempData) {
      if (val.saleRate != 0) {
        total -= val.saleRate!;
      }
      if (val.purchaseRate != 0) {
        total += val.purchaseRate!;
      }
    }
    setState(() {});
  }

  showDateFilter() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: Container(
                width: 320,
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: durationData.length,
                  itemBuilder: (context, index) => ListTile(
                    selected: index == durationIndex,
                    onTap: () {
                      durationIndex = index;
                      updateDuration(null);
                      if (durationIndex != 8) Navigator.pop(context);
                    },
                    dense: true,
                    title: Text(
                      durationData[index],
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ));
  }

  showDateRangeDailog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 10),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: Container(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select Date Range',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: WebDatePicker(
                            dateformat: 'dd-MM-yyyy',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            isFluent: true,
                            onChange: (val) {
                              start = val;
                            },
                            initialDate: start!,
                          ),
                        ),
                        const Text('  -  '),
                        Expanded(
                          child: WebDatePicker(
                            dateformat: 'dd-MM-yyyy',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            isFluent: true,
                            onChange: (val) {
                              end = val;
                            },
                            initialDate: end!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                              style: FilledButton.styleFrom(
                                  fixedSize: const Size(double.infinity, 32),
                                  minimumSize: const Size(double.infinity, 32),
                                  backgroundColor: Colors.blue.shade800,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                loading.value = true;
                                loadData();
                              },
                              child: Text(
                                'Update',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  fixedSize: const Size(double.infinity, 32),
                                  minimumSize: const Size(double.infinity, 32),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgd_1.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: !Navigator.of(context).canPop()
              ? IconButton(
                  onPressed: () {
                    mysql_class.screenKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu))
              : null,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white70),
          // leading: IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: () {
          //     Scaffold.of(context).openDrawer();
          //   },
          // ),
          backgroundColor: Colors.blue,
          elevation: 1,
          title: searchActive
              ? fl.TextFormBox(
                  autofocus: true,
                  controller: searchCnt,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  placeholder: ' Search ',
                  decoration: const BoxDecoration(color: Colors.white70),
                  placeholderStyle: const TextStyle(fontSize: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  onChanged: (val) {
                    searchData(val);
                  },
                )
              : Text(
                  'Transaction Report (${reportData.length})',
                  style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8)),
                ),
          actions: [
            if (!searchActive)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 14),
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
                child: Text(
                  'Excel',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                ),
                onPressed: () async {
                  exportExcelReport();
                },
              ),
            IconButton(
                onPressed: () {
                  setState(() {
                    searchActive = !searchActive;
                  });
                },
                icon: Icon(searchActive ? Icons.close : Icons.search)),
            const SizedBox(width: 10)
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<bool>(
                      valueListenable: loading,
                      builder: (context, loading, child) {
                        return loading
                            ? const Center(
                                heightFactor: 10, child: fl.ProgressBar())
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    IconButton(
                                        onPressed: durationIndex > 6
                                            ? null
                                            : () {
                                                updateDuration(false);
                                              },
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 20,
                                          color: Colors.white70,
                                        )),
                                    Expanded(
                                      child: ListTile(
                                        onTap: () {
                                          showDateFilter();
                                        },
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Icons.calendar_month,
                                          color: Colors.white70,
                                        ),
                                        title: Text(
                                            mysql_class.simpleCurreny(total,
                                                showSymbol: true),
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w500)),
                                        subtitle: Text(
                                            DateFormat('dd MMM yy -')
                                                    .format(start!) +
                                                DateFormat('dd MMM yy')
                                                    .format(end!),
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: durationIndex > 6
                                            ? null
                                            : () {
                                                updateDuration(true);
                                              },
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: Colors.white70,
                                        )),
                                  ]);
                      }),
                  const SizedBox(height: 3),
                  // if (false) ...[
                  //   const SizedBox(height: 3),
                  //   Row(children: [
                  //     SizedBox(
                  //       width: 80,
                  //       child: Text(
                  //         'Group by  ',
                  //         style: GoogleFonts.poppins(
                  //             color: Colors.white.withOpacity(0.8),
                  //             fontSize: 15,
                  //             fontWeight: FontWeight.w500),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: DropdowFeild(
                  //         style: GoogleFonts.poppins(
                  //             fontSize: 15,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.blue.shade800),
                  //         onChanged: (_) {
                  //           loaGroupData();
                  //         },
                  //         isFluent: true,
                  //         controller: groupCnt,
                  //         items: List.generate(
                  //             groupData.length,
                  //             (index) => DropdownFeildItem(
                  //                   value: groupData[index],
                  //                   onTap: () {},
                  //                   child: Text(
                  //                     groupData[index],
                  //                     style: GoogleFonts.poppins(
                  //                         color: Colors.black87,
                  //                         fontSize: 15,
                  //                         fontWeight: FontWeight.w500),
                  //                   ),
                  //                 )).toList(),
                  //       ),
                  //     ),
                  //   ])
                  // ],
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Colors.transparent,
                      ),
                  itemCount: pageIndex < reportData.length
                      ? pageIndex
                      : reportData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70,
                        surfaceTintColor: Colors.white70,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: groupCnt.text == 'Detail wise' ? 6 : 3),
                          dense: true,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "${reportData[index].brand!} ${reportData[index].model!}",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.5)),
                                    ),
                                    Text("${reportData[index].colourName}",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ]),
                              Divider(
                                height: 8,
                                color: Colors.grey.shade400,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Purchase Info',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        in_information(
                                                            reportData[index]
                                                                .purchaseID!)))
                                            .then((value) {
                                          if (value ?? false) {
                                            loadData();
                                          }
                                        });
                                      },
                                      child: Text(
                                        'View',
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue.shade400),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "No. ${reportData[index].purchaseNo!}",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                    Text(
                                        DateFormat('dd MMM yyyy').format(
                                            reportData[index].purchaseDate!),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ]),
                              const SizedBox(height: 3),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.person, size: 16),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          reportData[index].supplierName!,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                    Text(reportData[index].supplierMobile!,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.5)),
                                  ]),
                              const SizedBox(height: 3),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          'Executive: ' +
                                              reportData[index]
                                                  .purchaseExecutive!,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                  ]),
                              Divider(
                                height: 8,
                                color: Colors.grey.shade400,
                              ),
                              if (reportData[index].saleRate != 0) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text('Sale Info',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          out_information(
                                                              reportData[index]
                                                                  .saleID!)))
                                              .then((value) {
                                            if (value ?? false) {
                                              loadData();
                                            }
                                          });
                                        },
                                        child: Text(
                                          'View',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue.shade400),
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "No. ${reportData[index].saleNo!}",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15)),
                                      ),
                                      Text(
                                          DateFormat('dd MMM yyyy').format(
                                              reportData[index].saleDate!),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ]),
                                const SizedBox(height: 3),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                            reportData[index].customerName!,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15)),
                                      ),
                                      Text(reportData[index].customerMobile!,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.5)),
                                    ]),
                                const SizedBox(height: 3),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                            'Executive: ' +
                                                reportData[index]
                                                    .saleExecutive!,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15)),
                                      ),
                                    ]),
                                Divider(
                                  height: 8,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Purchase Rate',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ),
                                  if (reportData[index].saleRate != 0) ...[
                                    Expanded(
                                      child: Text('Sale Rate',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                    ),
                                    Expanded(
                                      child: Text('Profit',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14)),
                                    ),
                                  ]
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        mysql_class.simpleCurreny(
                                            reportData[index].purchaseRate,
                                            decimal: 0,
                                            showSymbol: false),
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                  ),
                                  if (reportData[index].saleRate != 0) ...[
                                    Expanded(
                                      child: Text(
                                          mysql_class.simpleCurreny(
                                              reportData[index].saleRate,
                                              decimal: 0,
                                              showSymbol: false),
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                    Expanded(
                                      child: Text(
                                          mysql_class.simpleCurreny(
                                              reportData[index].diffAmt,
                                              decimal: 0,
                                              showSymbol: false),
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.roboto(
                                              color: reportData[index]
                                                      .diffAmt!
                                                      .isNegative
                                                  ? Colors.red.shade500
                                                  : Colors.green.shade700,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Stocks_information(
                            //             reportData[index].id!))).then(
                            //     (value) {
                            //   if (value ?? true) {
                            //     loadData();
                            //   }
                            // });
                          },
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
