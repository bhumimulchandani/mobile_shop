import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:flutter/material.dart' as a;
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:shree_vimal_mobile_dhule/modal/license_info.dart';
import 'package:shree_vimal_mobile_dhule/modal/brand_report.dart';
import 'package:shree_vimal_mobile_dhule/modal/model_report.dart';
import 'package:shree_vimal_mobile_dhule/modal/transaction_report.dart';

class mysql_class {
  static GlobalKey<ScaffoldState> screenKey = GlobalKey();
  static String host_name = '193.203.184.47';
  static String user_name = 'u440085098_demo_mob_shop';
  static String user_pwd = '>1zuW5Ph';
  static String database_name = 'u440085098_demo_mob_shop';
  static List purchaseData = [];
  static int user_id = 0;
  static bool admin = false;
  static int port = 3306;
  static Uri uploadAPI =
      Uri.parse("https://shree-vimal-mobile.mezyapps.com/upload-media");
  static String imageURL =
      "https://shree-vimal-mobile.mezyapps.com/media/customer/";
  static String licenseKey = 'M176159692';
  static LicenseInfo? licenseInfo;
  static late MySQLConnection conn_settings;

  static int conn_yn = 0;
  static String lastInsertID = '0';

  static Future<void> getConnection_method() async {
    try {
      print("Connecting to mysql server...");

      // create connection
      conn_settings = await MySQLConnection.createConnection(
        host: host_name,
        port: port,
        userName: user_name,
        password: user_pwd,
        databaseName: database_name,
        collation: 'utf8_general_ci',
        secure: false,
      );
      await conn_settings.connect();
      conn_yn = 1;
    } catch (ex) {
      print(ex.toString());
    }
  }

  static Future<LicenseInfo?> checkLicense(String text) async {
    try {
      final param = {
        "key": licenseKey,
      };
      final reponse = await http.post(
        Uri.parse("https://api.registermykenan.com/check-validity"),
        body: param,
      );
      var responseData = json.decode(reponse.body);
      licenseInfo = (responseData as List)
          .map((data) => LicenseInfo.fromJson(data))
          .toList()
          .first;
      return licenseInfo;
    } catch (e) {
      return null;
    }
  }

  static simpleCurreny(val, {bool showSymbol = true, int decimal = 2}) =>
      NumberFormat.currency(
              locale: 'en-IN',
              decimalDigits: decimal,
              symbol: showSymbol ? '\u20B9 ' : '')
          .format(val);

  static InputDecoration searchableDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      filled: true,
      fillColor: Colors.white70);

  static late String public_conn_msg_value = "";

  Future<String> public_insert_update_delete_data_method(String query) async {
    await getConnection_method();
    public_conn_msg_value = "";
    try {
      var result = await conn_settings.execute(query);
      lastInsertID = result.lastInsertID.toString();
      return 'success';
    } catch (ex) {
      return ex.toString();
    }
  }

  Future<List> public_select_data_method(String query) async {
    await getConnection_method();
    public_conn_msg_value = "";

    List abcd = [];

    try {
      var result = await conn_settings.execute(query);

      for (final row in result.rows) {
        print(row.assoc());
      }
      abcd = result.rows.map((e) => e.assoc()).toList();
    } catch (ex) {
      public_conn_msg_value = ex.toString();
      debugPrint(public_conn_msg_value);
    }

    return abcd;
  }

  static Future<List<TransactionReport>> loadReport(
      DateTime start, DateTime end, String? modelID) async {
    await getConnection_method();

    try {
      var result = await conn_settings.execute(
          "select purchase.in_id as purchaseID, sale.in_id as saleID, purchase.brand, purchase.modelname as model, purchase.imeino1 as imeiNo,purchase.suppliername as supplierName,purchase.suppliernumber as supplierMobile,purchase.voucherno as purchaseNo,purchase.voucherdate as purchaseDate, ifnull(purchase.purchaserate,0) as purchaseRate, ifnull(sale.salerate,0) as saleRate,ifnull(sale.salerate,0)-ifnull(purchase.purchaserate,0) as diffAmt,sale.voucherno as saleNo, sale.voucherdate as saleDate,sale.customername as customerName,sale.customernumber as customerMobile,ifnull(sale.colourname,'') as colourName,purchase.warranty, purchase.paymentType, purchase.box, purchase.charger, purchase.bill, purchase.executive as purchaseExecutive, sale.saleexecutive as saleExecutive " +
              "from (SELECT a.in_id, a.voucherno, b.brand, b.modelname, a.imeino1, a.suppliername,a.suppliernumber,a.voucherdate, a.purchaserate,a.warranty, a.paymentType, a.box, a.charger, a.bill, a.executive FROM in_info_mst a left join model_mst b on b.model_id=a.model_id where ${modelID == null ? '' : 'a.model_id=$modelID and'} DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')<='${DateFormat('yyyy-MM-dd').format(end)}' and DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')>='${DateFormat('yyyy-MM-dd').format(start)}') purchase " +
              "left join (SELECT a.in_id,a.purchaseID,a.voucherno,  b.colourname, a.customername,a.customernumber,a.voucherdate, a.salerate, a.saleexecutive FROM out_info_mst a left join colour_mst b on b.colour_id=a.colour_id where ${modelID == null ? '' : 'a.model_id=$modelID and'} DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')<='${DateFormat('yyyy-MM-dd').format(end)}' and DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')>='${DateFormat('yyyy-MM-dd').format(start)}') as sale on purchase.in_id=sale.purchaseID;");

      //  "select purchase.in_id as purchaseID, sale.in_id as saleID, purchase.brand, purchase.modelname as model, purchase.imeino1 as imeiNo,purchase.accountname as supplierName,purchase.mobnumber as supplierMobile,purchase.voucherno as purchaseNo,purchase.voucherdate as purchaseDate, ifnull(purchase.purchaserate,0) as purchaseRate, ifnull(sale.salerate,0) as saleRate,ifnull(sale.salerate,0)-ifnull(purchase.purchaserate,0) as diffAmt,sale.voucherno as saleNo, sale.voucherdate as saleDate,sale.accountname as customerName,sale.mobnumber as customerMobile,ifnull(sale.colourname,'') as colourName,purchase.warranty, purchase.paymentType, purchase.box, purchase.charger, purchase.bill, purchase.executive as purchaseExecutive, sale.saleexecutive as saleExecutive " +
      //         "from (SELECT a.in_id, a.voucherno, b.brand, b.modelname, a.imeino1, c.accountname,c.mobnumber,a.voucherdate, a.purchaserate,a.warranty, a.paymentType, a.box, a.charger, a.bill, a.executive FROM in_info_mst a left join model_mst b on b.model_id=a.model_id left join supplier_mst c on c.supplier_id=a.supplier_id where ${modelID==null?'':'a.model_id=$modelID and'} DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')<='${DateFormat('yyyy-MM-dd').format(end)}' and DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')>='${DateFormat('yyyy-MM-dd').format(start)}') purchase " +
      //         "left join (SELECT a.in_id,a.purchaseID,a.voucherno,  b.colourname, c.accountname,c.mobnumber,a.voucherdate, a.salerate, a.saleexecutive FROM out_info_mst a left join colour_mst b on b.colour_id=a.colour_id left join supplier_mst c on c.supplier_id=a.customer_id where ${modelID==null?'':'a.model_id=$modelID and'} DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')<='${DateFormat('yyyy-MM-dd').format(end)}' and DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')>='${DateFormat('yyyy-MM-dd').format(start)}') as sale on purchase.in_id=sale.purchaseID;");

      var data = result.rows
          .map((e) => TransactionReport.fromJson(e.assoc()))
          .toList();
      return data;
    } catch (ex) {
      debugPrint(ex.toString());
      return [];
    }
  }

  static Future<List<BrandReport>> loadbrandReport(
      DateTime start, DateTime end) async {
    await getConnection_method();

    try {
      var result = await conn_settings.execute(
          "SELECT m.brand, COUNT(i.in_id) AS qty, SUM(i.purchaserate) AS amt FROM model_mst m JOIN in_info_mst i ON m.model_id = i.model_id WHERE i.in_id NOT IN (SELECT o.purchaseID FROM out_info_mst o) GROUP BY m.brand;");
      var data =
          result.rows.map((e) => BrandReport.fromJson(e.assoc())).toList();
      return data;
    } catch (ex) {
      debugPrint(ex.toString());
      return [];
    }
  }

  static Future<List<ModelReport>> loadmodelReport(
      DateTime start, DateTime end, String? brandName) async {
    await getConnection_method();

    try {
      var result = await conn_settings.execute(
          "SELECT m.model_id as modelID, m.modelname, COUNT(i.in_id) AS qty, SUM(i.purchaserate) AS amt FROM model_mst m JOIN in_info_mst i ON m.model_id = i.model_id WHERE m.brand='$brandName' and i.in_id NOT IN (SELECT o.purchaseID FROM out_info_mst o) AND m.brand= m.brand GROUP BY m.modelname;");
      var data =
          result.rows.map((e) => ModelReport.fromJson(e.assoc())).toList();
      return data;
    } catch (ex) {
      debugPrint(ex.toString());
      return [];
    }
  }

  // static Future<List<StockReport>> loadStockReport(String group, DateTime start,
  //     DateTime end, String brandID, String modelID) async {
  //   await getConnection_method();

  //   try {
  //     var BrandFilter = brandID == '' ? '' : 'and a.brand_id = $brandID';
  //     var ModelFilter = modelID == '' ? '' : 'and a.model_id= $modelID';
  //     var dateFilter =
  //         "where DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')<='${DateFormat('yyyy-MM-dd').format(end)}' and DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')>='${DateFormat('yyyy-MM-dd').format(start)}'";
  //     var query = group == 'Brand wise'
  //         ? "SELECT b.brand as 'brand', b.model_id as 'brandID', sum(ifnull(a.purchaserate,0)) as 'purchaserate' FROM `model_mst` b left join in_info_mst a on a.model_id=b.model_id $dateFilter group by b.brand;"
  //         : "SELECT b.modelname as 'model', a.model_id as 'modelID', sum(ifnull(a.purchaserate,0)) as 'purchaserate' FROM `model_mst` b left join in_info_mst a on a.model_id=b.model_id $dateFilter $BrandFilter group by b.modelname";

  //     var result = await conn_settings.execute(query);
  //     var data =
  //         result.rows.map((e) => StockReport.fromJson(e.assoc())).toList();
  //     return data;
  //   } catch (ex) {
  //     debugPrint(ex.toString());
  //     return [];
  //   }
  // }

  // static Future<List<StockReport>> loadStockReport(
  //     String group, DateTime start, DateTime end, String brandID, String modelID) async {
  //   await getConnection_method();

  //   try {
  //     var result = await conn_settings.execute(
  //         "select purchase.in_id as purchaseID, purchase.brand, purchase.modelname as model, purchase.imeino1 as imeiNo,purchase.accountname as supplierName,purchase.mobnumber as supplierMobile,purchase.voucherno as purchaseNo,purchase.voucherdate as purchaseDate, ifnull(purchase.purchaserate,0) as purchaseRate, purchase.warranty, purchase.paymentType, purchase.box, purchase.charger, purchase.bill, purchase.colourname as colourName " +
  //             "from (SELECT a.in_id, a.voucherno, b.brand, b.modelname, a.imeino1, c.accountname,c.mobnumber,a.voucherdate, a.purchaserate,a.warranty, a.paymentType, a.box, a.charger, a.bill, d.colourname FROM in_info_mst a left join model_mst b on b.model_id=a.model_id left join supplier_mst c on c.supplier_id=a.supplier_id left join colour_mst d on d.colour_id=a.colour_id where DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')<='${DateFormat('yyyy-MM-dd').format(end)}' and DATE_FORMAT(STR_TO_DATE(a.voucherdate, '%d-%m-%Y'), '%Y-%m-%d')>='${DateFormat('yyyy-MM-dd').format(start)}') purchase ;");
  //     var data =
  //         result.rows.map((e) => StockReport.fromJson(e.assoc())).toList();
  //     return data;
  //   } catch (ex) {
  //     debugPrint(ex.toString());
  //     return [];
  //   }
  // }

  static Future<void> scanBarcode(TextEditingController controller) async {
    try {
      final scannedCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scan line
        'Cancel', // Text for the cancel button
        true, // Whether to show the flash icon
        ScanMode.BARCODE, // Scan mode (Barcode or QR code)
      );

      if (scannedCode != '-1') {
        controller.text = scannedCode;
      }
    } catch (e) {
      // Handle any errors
      print('Error scanning barcode: $e');
    }
  }

  Future<int> existance_check(String table_name, String name_coloumn,
      String name_value, String id_column, String id_value, context) async {
    await getConnection_method();
    String existance_check = name_value.replaceAll("'", "''");

    int main_id = int.tryParse(id_value) ?? 0;
    var data_dt = await public_select_data_method("select " +
        id_column +
        " as existance_id from " +
        table_name +
        " where " +
        name_coloumn +
        "='" +
        existance_check +
        "' and " +
        id_column +
        "<>" +
        main_id.toString() +
        "");

    if (data_dt.length != 0) {
      String existance_id = data_dt[0]["existance_id"].toString();
      if (existance_id != "") {
        await mysql_class.show_confirmation_dialog_box(
            context, "Existance", "Name Already Exists", "Ok");
        return 1;
      }
    }

    return 0;
  }

  static show_confirmation_dialog_box(
      context, String heading, String disp_msg, String NO_BTN) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500)),
            content: Text(disp_msg,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500)),
            actions: [
              if (NO_BTN == 'Ok') ...[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("Ok",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500)))
              ] else ...[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("Yes",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500)))
              ]
            ],
          );
        });
  }

  static Future<String> uploadImg(String path, String imgName) async {
    try {
      Uint8List imageBytes1 = File(path).readAsBytesSync();
      img.Image image = path.contains('.png')
          ? img.decodePng(imageBytes1)!
          : img.decodeJpg(imageBytes1)!;
      if (image.width > 1200 || image.height > 1200) {
        img.Image newImage = image.width < image.height
            ? img.copyResize(image, height: 1200)
            : img.copyResize(image, width: 1200);
        imageBytes1 = img.encodeJpg(newImage, quality: 90);
      }

      var request = http.MultipartRequest('POST', uploadAPI);
      request.fields['name'] = imgName;
      request.fields['apikey'] = 'G3@f7X!p';
      request.files.add(http.MultipartFile.fromBytes('image', imageBytes1,
          filename: imgName));
      http.StreamedResponse res = await request.send();
      var resData = await http.Response.fromStream(res);
      var data = json.decode(resData.body);
      if (data['code'].toString() == '0') {
        return '';
      } else {
        return data['name'].toString();
      }
    } catch (e) {
      return '';
    }
  }

  Color textColor = Colors.white.withOpacity(0.8);
  Color dataColor = Colors.white.withOpacity(0.75);
  Color feildBackColor = Colors.white70;
  Color hintTextColors = Colors.black54;

  TextStyle h1Style =
      GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600);
  TextStyle h2Style =
      GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600);
  TextStyle h3Style =
      GoogleFonts.roboto(fontSize: 21, fontWeight: FontWeight.w600);
  TextStyle h4Style =
      GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w600);
  TextStyle h5Style =
      GoogleFonts.roboto(fontSize: 23, fontWeight: FontWeight.w600);
  TextStyle h6Style =
      GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w600);

  TextStyle formHeaderStyle = GoogleFonts.manrope(
    fontSize: 16,
    color: a.Colors.blue.shade900,
    fontWeight: FontWeight.w600,
  );
  TextStyle formTextStyle = GoogleFonts.roboto(
    fontSize: 16,
    color: a.Colors.black87,
    fontWeight: FontWeight.w500,
  );
}
