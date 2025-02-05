import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart' as a;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shree_vimal_mobile_dhule/colour_info.dart';
import 'package:shree_vimal_mobile_dhule/components/searchable_dropdown.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:shree_vimal_mobile_dhule/model_info.dart';

class in_information extends StatefulWidget {
  String main_id = "";

  in_information(this.main_id);

  @override
  State<in_information> createState() => _in_informationState();
}

class _in_informationState extends State<in_information> {
  final ImagePicker picker = ImagePicker();
  XFile? SupplierPhoto;
  String? supplierNetworkImage;

  var ob_mysql = mysql_class();

  String? _selectedCharger;
  String? _selectedBill;
  String? _selectedBox;
  String? _selectedPaymentType;

  TextEditingController vouchernoCnt = TextEditingController();
  TextEditingController vdateCnt = TextEditingController();
  TextEditingController suppliernameCnt = TextEditingController();
  TextEditingController supnumberCnt = TextEditingController();
  TextEditingController modelnameCnt = TextEditingController();
  TextEditingController imeino1Cnt = TextEditingController();
  TextEditingController imeino2Cnt = TextEditingController();
  TextEditingController colourCnt = TextEditingController();
  TextEditingController purchaserateCnt = TextEditingController();
  TextEditingController salerateCnt = TextEditingController();
  TextEditingController warrantyCnt = TextEditingController();
  TextEditingController executiveCnt = TextEditingController();
  TextEditingController remarksCnt = TextEditingController();

  TextEditingController add_modify_Cnt = TextEditingController(text: "ADD");

  TextStyle formHeaderStyle = GoogleFonts.manrope(
    fontSize: 16,
    color: a.Colors.blue.shade900,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();

    load_data();
    vdateCnt.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  void load_data() async {
    await select_max_vch_no_method();
    // await select_supplier_mst_method();
    await select_model_mst_method();
    await select_colour_mst_method();

    setState(() {});
    if (widget.main_id != "") {
      get_data_method_by_id();
    }
  }

  select_max_vch_no_method() async {
    var ab = await ob_mysql.public_select_data_method(
        "select ifnull(max(voucherno),0)+1 as max_no from in_info_mst");
    String max_no = ab[0]["max_no"].toString();
    setState(() {
      vouchernoCnt.text = max_no;
    });
  }

  List model_mst = [];
  String? selected_modelid = "";

  select_model_mst_method() async {
    String query = "SELECT model_id, modelname, brand, discount FROM model_mst";
    model_mst = await ob_mysql.public_select_data_method(query);
    setState(() {});
  }

  List colour_mst = [];
  String? selected_colourid = "";

  select_colour_mst_method() async {
    String query = "SELECT colour_id, colourname FROM colour_mst";
    colour_mst = await ob_mysql.public_select_data_method(query);
    setState(() {});
  }

  // List supplier_mst = [];
  // String? selected_supplierid = "";

  // select_supplier_mst_method() async {
  //   String query =
  //       "SELECT supplier_id, accounttype, accountname, mobnumber, address, gstno FROM supplier_mst where accounttype='Supplier'";
  //   supplier_mst = await ob_mysql.public_select_data_method(query);
  //   setState(() {});
  // }

  void save_and_update_button_method() async {
    if (await save_data_alert_method(context) == 1) {
      return;
    }

    if (SupplierPhoto != null) {
      supplierNetworkImage = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      mysql_class.uploadImg(SupplierPhoto!.path, supplierNetworkImage!);
    }

    String vc_no = vouchernoCnt.text.replaceAll("'", "''");
    String vdate = vdateCnt.text.replaceAll("'", "''");
    // String supid = selected_supplierid.toString();
    String supname = suppliernameCnt.text.replaceAll("'", "''");
    String supnum = supnumberCnt.text.replaceAll("'", "''");
    String modid = selected_modelid.toString();
    String imei1 = imeino1Cnt.text.replaceAll("'", "''");
    String imei2 = imeino2Cnt.text.replaceAll("'", "''");
    String colid = selected_colourid.toString();
    String prate = purchaserateCnt.text.replaceAll("'", "''");
    String srate = salerateCnt.text.replaceAll("'", "''");
    String warranty = warrantyCnt.text.replaceAll("'", "''");
    String sbox = _selectedBox.toString();
    String scharger = _selectedCharger.toString();
    String sbill = _selectedBill.toString();
    String spaymenttype = _selectedPaymentType.toString();
    String executive = executiveCnt.text.replaceAll("'", "''");
    String remarks = remarksCnt.text.replaceAll("'", "''");

    String query =
        "insert into in_info_mst(voucherno, voucherdate, suppliername, suppliernumber, model_id, imeino1, imeino2, colour_id, purchaserate, salerate, warranty, box, charger, bill, paymenttype, executive, remarks, supplierimage) values('$vc_no','$vdate','$supname','$supnum','$modid','$imei1','$imei2','$colid','$prate','$srate','$warranty','$sbox','$scharger','$sbill','$spaymenttype','$executive','$remarks','$supplierNetworkImage')";

    if (widget.main_id != "") {
      query =
          "update in_info_mst set voucherno='$vc_no', voucherdate='$vdate', suppliername='$supname', suppliernumber='$supnum', model_id='$modid', imeino1='$imei1', imeino2='$imei2', colour_id='$colid', purchaserate='$prate', salerate='$srate', warranty='$warranty', box='$sbox', charger='$scharger', bill='$sbill', paymenttype='$spaymenttype', executive='$executive', remarks='$remarks', supplierimage='$supplierNetworkImage' where in_id='${widget.main_id}'";
    }

    var status = await ob_mysql.public_insert_update_delete_data_method(query);
    if (status != 'success') {
      await mysql_class.show_confirmation_dialog_box(
          context, "Error occurred!", status, "Ok");
      return;
    }

    var data_dt = await ob_mysql.public_select_data_method(
        "select max(in_id) as max_id from in_info_mst");
    String max_id = data_dt[0]["max_id"].toString();
    if (widget.main_id != "") {
      max_id = widget.main_id;
    }

    Navigator.pop(context, true);
  }

  void delete_button_method(BuildContext context) async {
    if (widget.main_id != "") {
      bool confirmDelete = await mysql_class.show_confirmation_dialog_box(
          context,
          "Confirmation",
          "Do you want to delete this record?",
          "yes_no");

      // If the user confirms deletion
      if (confirmDelete) {
        String query =
            " delete from in_info_mst where in_id='${widget.main_id}'";

        var status =
            await ob_mysql.public_insert_update_delete_data_method(query);
        if (status != 'success') {
          await mysql_class.show_confirmation_dialog_box(
              context, "Error occurred!", status, "Ok");
          return;
        }

        Navigator.pop(context, true);
      }
    }
  }

  Future<int> save_data_alert_method(BuildContext context) async {
    if (vouchernoCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Voucher No", "Ok");
      return 1;
    }
    if (vdateCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Voucher Date", "Ok");
      return 1;
    }
    if (suppliernameCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Supplier Name", "Ok");
      return 1;
    }
    if (supnumberCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Supplier Number", "Ok");
      return 1;
    }
    // if (accountnameCnt.text.isEmpty || selected_supplierid.toString().isEmpty) {
    //   await mysql_class.show_confirmation_dialog_box(
    //       context, "Alert", "Please Select Account Name", "Ok");
    //   return 1;
    // }
    // if (mobnumberCnt.text.isEmpty || selected_supplierid.toString().isEmpty) {
    //   await mysql_class.show_confirmation_dialog_box(
    //       context, "Alert", "Please Select Account Name", "Ok");
    //   return 1;
    // }
    if (modelnameCnt.text.isEmpty || selected_modelid.toString().isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Alert", "Please Select Model Name", "Ok");
      return 1;
    }
    if (imeino1Cnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter IMEI1", "Ok");
      return 1;
    }
    if (imeino2Cnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter IMEI2", "Ok");
      return 1;
    }
    if (colourCnt.text.isEmpty || selected_colourid.toString().isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Alert", "Please Select Colour", "Ok");
      return 1;
    }
    if (purchaserateCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Purchase Rate", "Ok");
      return 1;
    }
    if (salerateCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Sale Rate", "Ok");
      return 1;
    }
    if (warrantyCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Warranty", "Ok");
      return 1;
    }
    if (_selectedBox == null || _selectedBox!.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Alert", "Please Select Box", "Ok");
      return 1;
    }
    if (_selectedCharger == null || _selectedCharger!.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Alert", "Please Select Charger", "Ok");
      return 1;
    }
    if (_selectedBill == null || _selectedBill!.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Alert", "Please Select Bill", "Ok");
      return 1;
    }
    if (_selectedPaymentType == null || _selectedPaymentType!.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Alert", "Please Select Payment Type", "Ok");
      return 1;
    }
    if (executiveCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Executive", "Ok");
      return 1;
    }

    return 0;
  }

  void reset_data() {
    this.setState(() {
      vouchernoCnt.clear();
      vdateCnt.clear();
      suppliernameCnt.clear();
      supnumberCnt.clear();
      modelnameCnt.clear();
      imeino1Cnt.clear();
      imeino2Cnt.clear();
      colourCnt.clear();
      purchaserateCnt.clear();
      salerateCnt.clear();
      warrantyCnt.clear();
      executiveCnt.clear();
      remarksCnt.clear();

      // selected_supplierid = "";
      selected_modelid = "";
      selected_colourid = "";
      _selectedBox = "";
      _selectedCharger = "";
      _selectedBill = "";
      _selectedPaymentType = "";

      widget.main_id = "";
      add_modify_Cnt.text = "Add";
    });
  }

  void get_data_method_by_id() async {
    String query =
        "select ii.in_id, ii.voucherno, ii.voucherdate, ii.suppliername, ii.suppliernumber, ii.model_id, mi.modelname, mi.brand, ii.imeino1, ii.imeino2, ii.colour_id, ci.colourname, ii.purchaserate, ii.salerate, ii.warranty, ii.box, ii.charger, ii.bill, ii.paymenttype, ii.executive, ii.remarks, ii.supplierimage from in_info_mst as ii inner join model_mst as mi on ii.model_id=mi.model_id inner join colour_mst as ci on ii.colour_id=ci.colour_id WHERE in_id='${widget.main_id}' Order by voucherdate desc, voucherno desc";

    var data_dt = await ob_mysql.public_select_data_method(query);

    vouchernoCnt.text = data_dt[0]["voucherno"].toString();
    vdateCnt.text = data_dt[0]["voucherdate"].toString();
    // selected_supplierid = data_dt[0]["supplier_id"].toString();
    suppliernameCnt.text = data_dt[0]["suppliername"].toString();
    supnumberCnt.text = data_dt[0]["suppliernumber"].toString();
    selected_modelid = data_dt[0]["model_id"].toString();
    modelnameCnt.text = '${data_dt[0]["brand"]} ${data_dt[0]["modelname"]}';
    imeino1Cnt.text = data_dt[0]["imeino1"].toString();
    imeino2Cnt.text = data_dt[0]["imeino2"].toString();
    selected_colourid = data_dt[0]["colour_id"].toString();
    colourCnt.text = data_dt[0]["colourname"].toString();
    purchaserateCnt.text = data_dt[0]["purchaserate"].toString();
    salerateCnt.text = data_dt[0]["salerate"].toString();
    warrantyCnt.text = data_dt[0]["warranty"].toString();
    _selectedBox = data_dt[0]["box"].toString();
    _selectedCharger = data_dt[0]["charger"].toString();
    _selectedBill = data_dt[0]["bill"].toString();
    _selectedPaymentType = data_dt[0]["paymenttype"].toString();
    executiveCnt.text = data_dt[0]["executive"].toString();
    remarksCnt.text = data_dt[0]["remarks"].toString();
    supplierNetworkImage = data_dt[0]["supplierimage"].toString(); //==''?NULL;
    add_modify_Cnt.text = "Modify";

    setState(() {});
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
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          title: Text(
            'Purchase Info : ${add_modify_Cnt.text}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Voucher No",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: a.TextFormField(
                          textCapitalization: TextCapitalization.words,
                          decoration: mysql_class.searchableDecoration,
                          autofocus: true,
                          controller: vouchernoCnt,
                          style: formHeaderStyle,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Voucher Date",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: a.TextFormField(
                          controller: vdateCnt,
                          style: formHeaderStyle,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              filled: true,
                              fillColor: Colors.white70),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              print(pickedDate);
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              print(formattedDate);
                              setState(() {
                                vdateCnt.text = formattedDate;
                              });
                            } else {}
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Expanded(
                    //   child: fu.InfoLabel(
                    //     label: "Supplier Name",
                    //     labelStyle: formHeaderStyle.copyWith(
                    //         color: Colors.blue.shade800),
                    //     child: SearchableDropdown<String>(
                    //       onSelected: (val) {
                    //         // FocusScope.of(context).nextFocus();
                    //       },
                    //       decoration: mysql_class.searchableDecoration,
                    //       noResultsFoundBuilder: (context) => const SizedBox(),
                    //       controller: accountnameCnt,
                    //       style: formHeaderStyle,
                    //       items: supplier_mst.map(
                    //         (asbx) {
                    //           return SearchableDropdownItem<String>(
                    //             value: asbx["accountname"].toString(),
                    //             label: asbx["accountname"].toString(),
                    //             onSelected: () {
                    //               setState(() {
                    //                 selected_supplierid =
                    //                     asbx["supplier_id"].toString();
                    //                 mobnumberCnt.text =
                    //                     asbx["mobnumber"].toString();
                    //               });
                    //             },
                    //           );
                    //         },
                    //       ).toList(),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Supplier Name",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: a.TextFormField(
                          textCapitalization: TextCapitalization.words,
                          decoration: mysql_class.searchableDecoration,
                          autofocus: true,
                          controller: suppliernameCnt,
                          style: formHeaderStyle,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Mobile No",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: a.TextFormField(
                          textCapitalization: TextCapitalization.words,
                          decoration: mysql_class.searchableDecoration,
                          autofocus: true,
                          controller: supnumberCnt,
                          style: formHeaderStyle,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    // IconButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => supplier_information(
                    //               "",
                    //               accountType: 'Supplier',
                    //             ),
                    //           )).then((value) {
                    //         if (value != null && value != true) {
                    //           // load supplier
                    //           select_supplier_mst_method();
                    //           // select suppler from list : [id,type,name, mobile];
                    //           if (value[1] == 'Supplier') {
                    //             selected_supplierid = value[0];
                    //             accountnameCnt.text = value[2];
                    //             mobnumberCnt.text = value[3];
                    //           }
                    //         }
                    //       });
                    //     },
                    //     icon: Icon(
                    //       Icons.add,
                    //       color: Colors.blue.shade700,
                    //     )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Model",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: SearchableDropdown<String>(
                          onSelected: (val) {
                            // FocusScope.of(context).nextFocus();
                          },
                          textInputAction: TextInputAction.none,
                          decoration: mysql_class.searchableDecoration,
                          noResultsFoundBuilder: (context) => const SizedBox(),
                          controller: modelnameCnt,
                          style: formHeaderStyle,
                          items: model_mst.map(
                            (asbx) {
                              return SearchableDropdownItem<String>(
                                value: "${asbx['brand']} ${asbx['modelname']}",
                                label: "${asbx['brand']} ${asbx['modelname']}",
                                onSelected: () {
                                  setState(() {
                                    selected_modelid =
                                        asbx["model_id"].toString();
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      model_information(""))).then((value) {
                            if (value != null && value != true) {
                              // load model
                              select_model_mst_method();
                              // select model from list : [id,brand,name];
                              selected_modelid = value[0];
                              modelnameCnt.text = '${value[1]} ${value[2]}';
                            }
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.blue.shade700,
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Imei No 1",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: a.TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: mysql_class.searchableDecoration,
                          autofocus: true,
                          controller: imeino1Cnt,
                          style: formHeaderStyle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      child: Text(
                        'Scan',
                        style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        mysql_class.scanBarcode(imeino1Cnt);
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: fu.InfoLabel(
                        label: "IMEI No 2",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: a.TextFormField(
                          textInputAction: TextInputAction.none,
                          textCapitalization: TextCapitalization.words,
                          decoration: mysql_class.searchableDecoration,
                          autofocus: true,
                          controller: imeino2Cnt,
                          style: formHeaderStyle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      child: Text(
                        'Scan',
                        style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      onPressed: () {
                        mysql_class.scanBarcode(imeino2Cnt);
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Colour",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: SearchableDropdown<String>(
                          onSelected: (val) {
                            // FocusScope.of(context).nextFocus();
                          },
                          decoration: mysql_class.searchableDecoration,
                          noResultsFoundBuilder: (context) => const SizedBox(),
                          controller: colourCnt,
                          style: formHeaderStyle,
                          items: colour_mst.map(
                            (asbx) {
                              return SearchableDropdownItem<String>(
                                value: asbx["colourname"].toString(),
                                label: asbx["colourname"].toString(),
                                onSelected: () {
                                  setState(() {
                                    selected_colourid =
                                        asbx["colour_id"].toString();
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      colour_information(""))).then((value) {
                            if (value != null && value != true) {
                              // load color
                              select_colour_mst_method();
                              // select color from list : [id,name];
                              selected_colourid = value[0];
                              colourCnt.text = value[1];
                            }
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.blue.shade700,
                        )),
                  ],
                ),
                fu.InfoLabel(
                  label: "Purchase Rate",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    textCapitalization: TextCapitalization.words,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: purchaserateCnt,
                    style: formHeaderStyle,
                  ),
                ),
                fu.InfoLabel(
                  label: "Sale Rate",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    textCapitalization: TextCapitalization.words,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: salerateCnt,
                    style: formHeaderStyle,
                  ),
                ),
                fu.InfoLabel(
                  label: "Warranty",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: warrantyCnt,
                    style: formHeaderStyle,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                fu.InfoLabel(
                  label: 'Box',
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: DropdownButtonFormField<String>(
                    value: _selectedBox,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white70,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    dropdownColor: Colors.grey.shade200,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      FocusScope.of(context).nextFocus();
                      setState(() {
                        _selectedBox = newValue;
                      });
                    },
                    items: ['Yes', 'No']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                fu.InfoLabel(
                  label: 'Charger',
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCharger,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white70,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    dropdownColor: Colors.grey.shade200,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      FocusScope.of(context).nextFocus();
                      setState(() {
                        _selectedCharger = newValue;
                      });
                    },
                    items: ['Yes', 'No']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                fu.InfoLabel(
                  label: 'Bill',
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: DropdownButtonFormField<String>(
                    value: _selectedBill,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white70,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    dropdownColor: Colors.grey.shade200,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      FocusScope.of(context).nextFocus();
                      setState(() {
                        _selectedBill = newValue;
                      });
                    },
                    items: ['Yes', 'No']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                fu.InfoLabel(
                  label: 'Payment Type',
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: DropdownButtonFormField<String>(
                    value: _selectedPaymentType,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white70,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    dropdownColor: Colors.grey.shade200,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      FocusScope.of(context).nextFocus();
                      setState(() {
                        _selectedPaymentType = newValue;
                      });
                    },
                    items: ['Cash', 'Exchange']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                fu.InfoLabel(
                  label: "Executive",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: executiveCnt,
                    style: formHeaderStyle,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                fu.InfoLabel(
                  label: "Remarks",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: remarksCnt,
                    style: formHeaderStyle,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black12)),
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        SupplierPhoto != null
                            ? Expanded(
                                child: Image.file(File(SupplierPhoto!.path)))
                            : supplierNetworkImage.toString() != 'null' &&
                                    supplierNetworkImage != ''
                                ? Expanded(
                                    child: Image.network(
                                      mysql_class.imageURL +
                                          supplierNetworkImage!,
                                      errorBuilder: (context, obj, error) =>
                                          Center(
                                              child: Text(
                                                  'Error loading Image' +
                                                      supplierNetworkImage!)),
                                    ),
                                  )
                                : Expanded(
                                    child: Center(
                                        child: Text('Select Image',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54))),
                                  ),
                        Divider(height: 1, color: Colors.grey.shade400),
                        Row(
                          children: [
                            Expanded(
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3))),
                                    onPressed: () async {
                                      await picker
                                          .pickImage(
                                              source: ImageSource.gallery)
                                          .then((val) {
                                        if (val != null) {
                                          setState(() {
                                            SupplierPhoto = val;
                                          });
                                        }
                                      });
                                    },
                                    child: Text(
                                      'Choose Photo',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500),
                                    ))),
                            Expanded(
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      minimumSize: Size.zero,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 5),
                                    ),
                                    onPressed: () async {
                                      await picker
                                          .pickImage(
                                              maxHeight: 1200,
                                              maxWidth: 1200,
                                              source: ImageSource.camera)
                                          .then((val) {
                                        if (val != null) {
                                          setState(() {
                                            SupplierPhoto = val;
                                          });
                                        }
                                      });
                                    },
                                    child: Text(
                                      'Capture Photo',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500),
                                    ))),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          save_and_update_button_method();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          widget.main_id == '' ? 'Save' : 'Update',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    if (widget.main_id != '') ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            delete_button_method(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            backgroundColor: Colors.red.shade600,
                          ),
                          child: Text('Delete',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 16)),
                        ),
                      )
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
